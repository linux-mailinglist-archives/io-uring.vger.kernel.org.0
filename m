Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17FAD4553E7
	for <lists+io-uring@lfdr.de>; Thu, 18 Nov 2021 05:42:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243050AbhKREpi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 Nov 2021 23:45:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243046AbhKREpa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 17 Nov 2021 23:45:30 -0500
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E89BC061570
        for <io-uring@vger.kernel.org>; Wed, 17 Nov 2021 20:42:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Date:Message-ID:From:Cc:To;
        bh=yBBgysEzjJtNYa1vjNmvr8wR8apRrw3portjJ4PTUXQ=; b=1kONjglbTfp0GYofcZL4zc4QCd
        KjKfMSk+axzviaHS2P+mRWJlUBmlfs951P2VdNrV715uDUMnzlZlBbvOBx6Hb7WVpaTITgv3Mc+hN
        VTDmOZQyCbbDBhR64IjtouiZGfMF7Jh9eK04BpoTF11jP9CqTLOGajIafvvUsJe7jqf68e8px7pQx
        s/MgYRZqXgYt/8du6g9fbaRs2k6z9YtoPQfQCNhRcKIsX+tqTHnU1MrdrykiLMUyvFiizhq76i2hO
        E/LjR3m49Znh2GrDFAaHnx8F4Ue8NEOqzRM/XVzWSWkSVy9zCynrH2SCeTaSrYRQEpdwaYRVtLPzS
        F7QyTL7NNZMNSCBigMw3xzfKwhBaQayco5JLRdg3zP7I07DkaIkk+MG2aCknL4/+2sCgPmUXULPJN
        OXnuLTaCmm/qiAWKnjfh31G5vLFQFscrDtKdxCPeDCiHGyL8xXVib9eQe0nhbAEobRmHmzIW7P4IL
        YT2DabuBSVC9q/VUEj2BGDTC;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mnZFj-007ewU-IH; Thu, 18 Nov 2021 04:42:27 +0000
Subject: Re: [PATCH v2 3/7] debian/rules: fix for newer debhelper
To:     Eric Wong <e@80x24.org>, io-uring@vger.kernel.org
Cc:     Liu Changcheng <changcheng.liu@aliyun.com>
References: <20211118031016.354105-1-e@80x24.org>
 <20211118031016.354105-4-e@80x24.org>
From:   Stefan Metzmacher <metze@samba.org>
Message-ID: <4a3f4693-40dc-ec48-e25b-904dd73343b1@samba.org>
Date:   Thu, 18 Nov 2021 05:42:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211118031016.354105-4-e@80x24.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Am 18.11.21 um 04:10 schrieb Eric Wong:
> When testing on my Debian 11.x (stable) system, --add-udeb
> causes the following build error:
> 
>   dh_makeshlibs: error: The udeb liburing1-udeb does not contain any shared librar
>   ies but --add-udeb=liburing1-udeb was passed!?
>   make: *** [debian/rules:82: binary-arch] Error 255
> 
> Reading the current dh_makeshlibs(1) manpage reveals --add-udeb
> is nowadays implicit as of debhelper 12.3 and no longer
> necessary.  Compatibility with older debhelper on Debian
> oldstable (buster) remains intact.  Tested with debhelper 12.1.1
> on Debian 10.x (buster) and debhelper 13.3.4 on Debian 11.x
> (bullseye).
> 
> Signed-off-by: Eric Wong <e@80x24.org>
> ---
>  debian/rules | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/debian/rules b/debian/rules
> index 1a334b3..fe90606 100755
> --- a/debian/rules
> +++ b/debian/rules
> @@ -70,7 +70,14 @@ binary-arch: install-arch
>  	dh_strip -a --ddeb-migration='$(libdbg) (<< 0.3)'
>  	dh_compress -a
>  	dh_fixperms -a
> -	dh_makeshlibs -a --add-udeb '$(libudeb)'
> +
> +# --add-udeb is needed for < 12.3, and breaks with auto-detection
> +#  on debhelper 13.3.4, at least
> +	if perl -MDebian::Debhelper::Dh_Version -e \
> +	'exit(eval("v$$Debian::Debhelper::Dh_Version::version") lt v12.3)'; \
> +		then dh_makeshlibs -a; else \
> +		dh_makeshlibs -a --add-udeb '$(libudeb)'; fi
> +

I have this:

$ lsb_release -a
No LSB modules are available.
Distributor ID: Ubuntu
Description:    Ubuntu 20.04.3 LTS
Release:        20.04
Codename:       focal
$ perl -MDebian::Debhelper::Dh_Version -e 'print "$Debian::Debhelper::Dh_Version::version\n";'
12.10ubuntu1

and it needs the --add-udeb argument.

So this still fails for me.

metze


