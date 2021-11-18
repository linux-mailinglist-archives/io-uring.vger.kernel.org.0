Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7362455E57
	for <lists+io-uring@lfdr.de>; Thu, 18 Nov 2021 15:37:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbhKROkr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 18 Nov 2021 09:40:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbhKROkr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 18 Nov 2021 09:40:47 -0500
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7EE1C061574
        for <io-uring@vger.kernel.org>; Thu, 18 Nov 2021 06:37:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Date:Message-ID:From:Cc:To;
        bh=uVRi+8RIKjUAy9PkUbqwmBKJahIZjR/5G0FcTcpJkA4=; b=4AcP/pxBLUpOvmvD0BBgvSBiU6
        47wQQmF5tdrWwAUN2D1lruBSxBO3G8hus7aHokA7zjOOsw3L5FEPqXT2ALxMCEG2yhtqNic9gTX5Z
        rX12+ocHWPMFL/1xUmumyVWjYOt7DEZebmJEXH1TlzgcWfQu6DNlrvMQIu3/j0xivvH7qkiV148K6
        AxMGVnkmOEjAIIKYKEBvZ/jBhzKxZJHZSW4Jh8XjerUdiiElzHUe7QtJN1l4clEMinov7lFeJrzu7
        e/JcxfSWaKn5Z+GKEsPSFtpkYTHbCjh9e1qSCTSb7PIAj30nxX3Owa1Z15hExkokaa65ow83vMAF3
        Vjx5fa0aD23bQYT8LaeJp2sLwb0M3abcFxZ70nWTHZDGtlan6dU37Xn6nZQ+2uILxB3U2dtq01GgD
        z55JRVUa+s71Ihd7rFyWBf/fEm+XRUl6CvE4+cc1/xOzjDWACG9QhawVYDGsBftKdA5xGxKRrsqyW
        rzg6IJSPp+qV3MINcyfcN4uz;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mniXn-007l1p-LF; Thu, 18 Nov 2021 14:37:43 +0000
Subject: Re: [PATCH v2 3/7] debian/rules: fix for newer debhelper
To:     Eric Wong <e@80x24.org>
Cc:     io-uring@vger.kernel.org,
        Liu Changcheng <changcheng.liu@aliyun.com>
References: <20211118031016.354105-1-e@80x24.org>
 <20211118031016.354105-4-e@80x24.org>
 <4a3f4693-40dc-ec48-e25b-904dd73343b1@samba.org>
 <20211118051150.GA10496@dcvr> <20211118053512.M750014@dcvr>
From:   Stefan Metzmacher <metze@samba.org>
Message-ID: <8ccd3b34-bd3a-6c9f-fdb6-64d1b3b43f64@samba.org>
Date:   Thu, 18 Nov 2021 15:37:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211118053512.M750014@dcvr>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Eric,

> Sorry, I missed a semi-colon and temporarily lost connectivity
> to my bullseye machine :x  Tested on both bullseye and buster, now
> 
> diff --git a/debian/rules b/debian/rules
> index cd41bb8..d0b4eea 100755
> --- a/debian/rules
> +++ b/debian/rules
> @@ -84,7 +84,8 @@ binary-arch: install-arch
>  # --add-udeb is needed for < 12.3, and breaks with auto-detection
>  #  on debhelper 13.3.4, at least
>  	if perl -MDebian::Debhelper::Dh_Version -e \
> -	'exit(eval("v$$Debian::Debhelper::Dh_Version::version") lt v12.3)'; \
> +	'($$v) = ($$Debian::Debhelper::Dh_Version::version =~ /\A([\d\.]+)/);' \
> +	-e 'exit(eval("v$$v") lt v12.3)'; \
>  		then dh_makeshlibs -a; else \
>  		dh_makeshlibs -a --add-udeb '$(libudeb)'; fi
>  

That seems to work, thanks!

metze

