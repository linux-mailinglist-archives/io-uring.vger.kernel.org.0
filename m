Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEFF45FE5D2
	for <lists+io-uring@lfdr.de>; Fri, 14 Oct 2022 01:12:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229491AbiJMXMo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 13 Oct 2022 19:12:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbiJMXMn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 13 Oct 2022 19:12:43 -0400
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D9E816C20C
        for <io-uring@vger.kernel.org>; Thu, 13 Oct 2022 16:12:42 -0700 (PDT)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-360871745b0so31577257b3.3
        for <io-uring@vger.kernel.org>; Thu, 13 Oct 2022 16:12:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Lt9cb6+m2a/i6PiYe0RZ8O8lpsfOHp+Jqx8k9cZPDq0=;
        b=il2G5gK6+h56Oqrdct99u/YWhI8TedjtdDWSx49VHjlG/oN20VyRfZFxreYSzmu7WR
         VlVksRTD+BnbUJbmXTYNSPDNMwSm8sRMsbHL5BvlFWHwqZ1I7dsEQ24GZhwXtIDB6+7B
         Wtod6+z2eXCzxSJdj0Kq5uq+Di/kryPPbuwkW42+SR+HTyrbgIVn08+x6bXsmP01qH72
         wJWDf2Pui+8xBxhec+nZHMIUNgWjzJedSuUvdOHytI71/6DE7uJKaMQKlEH6wA86hHk7
         9o4C9px5Wm2Cwu9vOnaW6NO6lmdYiuoivHOVIikPaXUTqUN19DuJumjbHqtZYQuQvwoK
         D8PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Lt9cb6+m2a/i6PiYe0RZ8O8lpsfOHp+Jqx8k9cZPDq0=;
        b=hqpeXyCh+qAp252xX0IpCRbcGttJuRDRGtJ2rmrBuPjTv8sAmNsjuSPk09w1603Fg2
         kfJvxRakDwyf3Ei6NIRYI1wdVfY4kLMNE11P+LOp83XolRoKz7nXBbcv0bJAjVes/xeJ
         8gXaMMCSQp7HTfUKiRz5oAoIZ2m7KZWtXwGiNAaCTBgr/z31QYKxpaDXPmuKiZjsXn8U
         r3k2SFdU6otnpIXOCb4J4stUX/yf6os2HlXdtOMaLTEKKP8JJ5G9W4I3QLt5e00psPjZ
         fHOVZQkv3ACGT1kwiqqVaszb6NesRPrb5HjcRZ/e7fudVMKd55viH6KA03g80GRJsAt6
         FW5Q==
X-Gm-Message-State: ACrzQf3Pfr6wJBZiMdFC/GGgoAAf3u4s+eYa30ElX1ZfH1i9olP9gW0n
        XVaJ5eKarLcoaidgYtl6wpDwW9Wtpim/tS2oMX4cjoE25w==
X-Google-Smtp-Source: AMsMyM4Gnbxnp16yXQxmAUR9ZoMJM63jvz8gG3ekKrgZWt/ck0aXsyA2kGFmxXs7BRrZkuOVPaWrkuiLUqSVP7QVpAs=
X-Received: by 2002:a81:f84:0:b0:357:c499:44e6 with SMTP id
 126-20020a810f84000000b00357c49944e6mr2152912ywp.51.1665702761025; Thu, 13
 Oct 2022 16:12:41 -0700 (PDT)
MIME-Version: 1.0
References: <CAHC9VhQCLQogAFSvAy4AtL8VzHX9dtUetFsV2HpqR0FVWkiiYQ@mail.gmail.com>
 <85403545-DA41-49AE-834D-AAD9993FF429@kernel.dk>
In-Reply-To: <85403545-DA41-49AE-834D-AAD9993FF429@kernel.dk>
From:   Paul Moore <paul@paul-moore.com>
Date:   Thu, 13 Oct 2022 19:12:29 -0400
Message-ID: <CAHC9VhTqN4hmzGaPRpocV-EDBwTidj60jWzHKHkt=YaUwM8RDg@mail.gmail.com>
Subject: Re: [PATCH] io_uring/opdef: remove 'audit_skip' from SENDMSG_ZC
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Oct 13, 2022 at 7:10 PM Jens Axboe <axboe@kernel.dk> wrote:
> On Oct 13, 2022, at 4:58 PM, Paul Moore <paul@paul-moore.com> wrote:
> > =EF=BB=BFOn Fri, Oct 7, 2022 at 2:35 PM Paul Moore <paul@paul-moore.com=
> wrote:
> >>> On Fri, Oct 7, 2022 at 2:28 PM Jens Axboe <axboe@kernel.dk> wrote:
> >>>
> >>> The msg variants of sending aren't audited separately, so we should n=
ot
> >>> be setting audit_skip for the zerocopy sendmsg variant either.
> >>>
> >>> Fixes: 493108d95f14 ("io_uring/net: zerocopy sendmsg")
> >>> Reported-by: Paul Moore <paul@paul-moore.com>
> >>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> >>
> >> Thanks Jens.
> >>
> >> Reviewed-by: Paul Moore <paul@paul-moore.com>
> >
> > Hi Jens, I just wanted to check on this, are you planning to send this
> > to Linus during the v6.1-rcX cycle?
>
> Yes, it was included in the pull sent out earlier today.

Great, thanks again for your help in taking care of this.

--=20
paul-moore.com
