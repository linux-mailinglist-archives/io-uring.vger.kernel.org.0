Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E18C4EC7E6
	for <lists+io-uring@lfdr.de>; Wed, 30 Mar 2022 17:13:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244124AbiC3POo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 30 Mar 2022 11:14:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238687AbiC3POn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 30 Mar 2022 11:14:43 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D7572AE30
        for <io-uring@vger.kernel.org>; Wed, 30 Mar 2022 08:12:57 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id bh17so2689539ejb.8
        for <io-uring@vger.kernel.org>; Wed, 30 Mar 2022 08:12:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0Mt0iqI8NgPnqJpJSrxtTBJCkN35gtulZa2EkVMb+B8=;
        b=F0KpY7ampbS6+0GR68DRUxolDvrfZMD31WMsYfIlEK1B4n/bCu1qwlkgA8yO24qoM/
         /JllMTabaLsLjUIIjxbGJqoyeCKm891uu8wLSEP/x6DWcWK+paB6NFV6N0cMALLYYe7A
         7bmLtjAmLIB+Wr0VG/EiuSTP1sNwhzb3eNxW8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0Mt0iqI8NgPnqJpJSrxtTBJCkN35gtulZa2EkVMb+B8=;
        b=xQAyTCGwMvSqdj7jIMpyU9EdSFW3tj2PQjeV9nQmKbTz8sLHbM28EdR8ldaA7N7Lc8
         i+AecJjJGhkMAZdOUn8TKVVZYxGH40JqnfqJlLoR6gZheF7D86Poafe5hRyEEEALxh8O
         nRzqt7bRBwROPWPngHUMp7mKUXXoS7t5d+z0A5WEtfFYQ8Zb1K4WdlDXfcxlJjp9X6AB
         trP7r7+0EctxxaOfly7b63s7H51pw36tjdREwyk2fOnOBs97inLL/g+eoivqTAb6DS2I
         M8SEyYUZSSy3cCHGEcwR15p3PrntZu40Arp22w3MXzEM7YOJlLhCv5+2hk4IBVGXXd9r
         nV+A==
X-Gm-Message-State: AOAM530GgRArvI4GAbYMOMTsoit22DQiIoJzIuG2BPkGsDDLLgb6ZBDb
        h7qhg/AzL8Uwa8GtzF7oU8uKU2oLLRwo/qj3V99cFA==
X-Google-Smtp-Source: ABdhPJz0C6HCh/NY2asSqcmb+2OVCCHLTcb/4tij50j2EC7795RTwd191FjfuCiTn2KbfphD4goUXKd1yOfSVPmaqXE=
X-Received: by 2002:a17:906:280b:b0:6ce:f3c7:688f with SMTP id
 r11-20020a170906280b00b006cef3c7688fmr39810484ejc.468.1648653175859; Wed, 30
 Mar 2022 08:12:55 -0700 (PDT)
MIME-Version: 1.0
References: <CAJfpegvVpFbDX5so8EVaHxubZLNQ4bo=myAYopWeRtMs0wa6nA@mail.gmail.com>
 <8145e724-d960-dd85-531e-16e564a02f05@kernel.dk> <c8872b69-f042-dc35-fa3d-6862f09a5385@kernel.dk>
 <CAJfpegs1o3HNkpxPa85LmNCoVVk-T2rt3vJXBvRf_M93P+6ouA@mail.gmail.com>
 <115fc7d1-9b9c-712b-e75d-39b2041df437@kernel.dk> <CAJfpegs=GcTuXcor-pbhaAxDKeS5XRy5rwTGXUcZM0BYYUK2LA@mail.gmail.com>
 <89322bd1-5e6f-bcc6-7974-ffd22363a165@kernel.dk> <CAJfpegtr+Bo0O=i9uShDJO_=--KAsFmvdzodwH6qF7f+ABeQ5g@mail.gmail.com>
 <0c5745ab-5d3d-52c1-6a1d-e5e33d4078b5@kernel.dk> <CAJfpegtob8ZWU1TDBoUf7SRMQJhEcEo2sPUumzpNd3Mcg+1aog@mail.gmail.com>
 <52dca413-61b3-8ded-c4cc-dd6c8e8de1ed@kernel.dk> <CAJfpegtEG2c3H8ZyOWPT69HJN2UWU1es-n9P+CSgV7jiZMPtGg@mail.gmail.com>
 <23b62cca-8ec5-f250-e5a3-7e9ed983e190@kernel.dk> <CAJfpeguZji8x+zXSADJ4m6VKbdmTb6ZQd5zA=HCt8acxvGSr3w@mail.gmail.com>
 <CAJfpegsADrdURSUOrGTjbu1DoRr7-8itGx23Tn0wf6gNdO5dWA@mail.gmail.com> <77229971-72cd-7d78-d790-3ef4789acc9e@kernel.dk>
In-Reply-To: <77229971-72cd-7d78-d790-3ef4789acc9e@kernel.dk>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Wed, 30 Mar 2022 17:12:44 +0200
Message-ID: <CAJfpeguiZ7U=YQhgGa-oPWO07tpBL6sf3zM=xtAk66njb1p2cw@mail.gmail.com>
Subject: Re: io_uring_prep_openat_direct() and link/drain
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, 30 Mar 2022 at 17:05, Jens Axboe <axboe@kernel.dk> wrote:
>
> On 3/30/22 8:58 AM, Miklos Szeredi wrote:
> > Next issue:  seems like file slot reuse is not working correctly.
> > Attached program compares reads using io_uring with plain reads of
> > proc files.
> >
> > In the below example it is using two slots alternately but the number
> > of slots does not seem to matter, read is apparently always using a
> > stale file (the prior one to the most recent open on that slot).  See
> > how the sizes of the files lag by two lines:
> >
> > root@kvm:~# ./procreads
> > procreads: /proc/1/stat: ok (313)
> > procreads: /proc/2/stat: ok (149)
> > procreads: /proc/3/stat: read size mismatch 313/150
> > procreads: /proc/4/stat: read size mismatch 149/154
> > procreads: /proc/5/stat: read size mismatch 150/161
> > procreads: /proc/6/stat: read size mismatch 154/171
> > ...
> >
> > Any ideas?
>
> Didn't look at your code yet, but with the current tree, this is the
> behavior when a fixed file is used:
>
> At prep time, if the slot is valid it is used. If it isn't valid,
> assignment is deferred until the request is issued.
>
> Which granted is a bit weird. It means that if you do:
>
> <open fileA into slot 1, slot 1 currently unused><read slot 1>
>
> the read will read from fileA. But for:
>
> <open fileB into slot 1, slot 1 is fileA currently><read slot 1>
>
> since slot 1 is already valid at prep time for the read, the read will
> be from fileA again.
>
> Is this what you are seeing? It's definitely a bit confusing, and the
> only reason why I didn't change it is because it could potentially break
> applications. Don't think there's a high risk of that, however, so may
> indeed be worth it to just bite the bullet and the assignment is
> consistent (eg always done from the perspective of the previous
> dependent request having completed).
>
> Is this what you are seeing?

Right, this explains it.   Then the only workaround would be to wait
for the open to finish before submitting the read, but that would
defeat the whole point of using io_uring for this purpose.

Thanks,
Miklos
