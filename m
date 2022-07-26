Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AEFD580AA1
	for <lists+io-uring@lfdr.de>; Tue, 26 Jul 2022 07:00:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231828AbiGZFAo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Jul 2022 01:00:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230410AbiGZFAo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Jul 2022 01:00:44 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AF1D2616;
        Mon, 25 Jul 2022 22:00:43 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id bp15so24125908ejb.6;
        Mon, 25 Jul 2022 22:00:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mAobhmxY2NtqJO44elG6BHfmCqS59Vr63Jbshv576Aw=;
        b=eHgPkMskAd3ZWjLVaUuC8HwPL/gtfujJ7bJIUqDmstfBhPHsWTcjqmIkGlugqqh+DJ
         cyTznqAi1rP2XGGyktSOjS+5jBQXDBAoA8ORZoVeeWjUfHB91gTgrzF645oUNXiYFWmL
         jmRcobygiBwJLRVDyJajHVySlGgsKDJlVZ/F5s1syZPuq7sf4NDUps846gOVeTwWy5jS
         GzCzh4Mh+MJvh9pC+M7Nzfgdt2uzTTA8wm2huDVCvu0ago2ZrTa8MgwrQDU3sIqZWbL/
         vXf3RPBHSu9dQ2iujoD2Cn+n41gwBzNzcE7eVErfT33apwQiphwIJvuZehll6PXrs0y/
         WxJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mAobhmxY2NtqJO44elG6BHfmCqS59Vr63Jbshv576Aw=;
        b=tXGTuKlK6FIPV6UMYA5Teqph/9yvCyujZ4hTS90zGp1IUJryzcrSLQJ5FzRyM+NsYp
         gJSkyJiimIRzQgYoG7Q1xIw+CmOI4EgPSZHgDDnT+Ju3hOVVE+PTTTaMuywT/mP3+xMd
         U7NQM6i3KCsSozxop7vUt9mRzCNlsGTJ+IH9/CWTIdNiXTr/abGrzAVPs6SKv9giBnNh
         7JpQUwqPQEJZ2zIQlKGXJYjDTCiahDd5ipEmaOKUR16MUatE3qiP6hE135aiQN9rknkE
         +HFzKED0CGtN4ONy3stg1k6fOtoIJJGvDLPZZEp9A3U6HsomIzt6vYvI/jsO5coyg+1n
         ZC4Q==
X-Gm-Message-State: AJIora92rruMMwuaOONLZChqcTaROUvBcFxN0FPm6TTG0odnp1rvwCLi
        dDsW2KY8hHN6w4QTAwLSdUCBxIj4YieZIWOim7E=
X-Google-Smtp-Source: AGRyM1tc0KaeAbmNTCOG0nvtMte4+RfPtEeY6LLILCMf/jB3WMRqpbYtOz4oqKWolG9ODQot6yraAD2aN9hoX3yAJCM=
X-Received: by 2002:a17:907:a05b:b0:72b:33f9:f927 with SMTP id
 gz27-20020a170907a05b00b0072b33f9f927mr12975671ejc.707.1658811641863; Mon, 25
 Jul 2022 22:00:41 -0700 (PDT)
MIME-Version: 1.0
References: <CANX2M5YiZBXU3L6iwnaLs-HHJXRvrxM8mhPDiMDF9Y9sAvOHUA@mail.gmail.com>
 <e21e651299a4230b965cf79d4ae9efd1bc307491.camel@fb.com> <CANX2M5YXHVTZfst7h5vkPtyt-xBTn1-zsoA=XUAWztbVurioOA@mail.gmail.com>
In-Reply-To: <CANX2M5YXHVTZfst7h5vkPtyt-xBTn1-zsoA=XUAWztbVurioOA@mail.gmail.com>
From:   Dipanjan Das <mail.dipanjan.das@gmail.com>
Date:   Mon, 25 Jul 2022 22:00:30 -0700
Message-ID: <CANX2M5aYZ2kj+OZHUQF78O_fZoF0Oegytx4iFKjU+mAf9JtQbA@mail.gmail.com>
Subject: Re: KASAN: use-after-free Read in __io_remove_buffers
To:     Dylan Yudaken <dylany@fb.com>
Cc:     "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>,
        "fleischermarius@googlemail.com" <fleischermarius@googlemail.com>,
        "syzkaller@googlegroups.com" <syzkaller@googlegroups.com>,
        "its.priyanka.bose@gmail.com" <its.priyanka.bose@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

> On Thu, Jul 21, 2022 at 4:06 AM Dylan Yudaken <dylany@fb.com> wrote:
> >
> > Both of the bug reports you sent seem to be fixed by the patch I just
> > sent.
> >
> > This one however does not seem to terminate once fixed. Is there an
> > expected run time?
>

We can confirm that the C-repro hangs while the syz-repro does not.
For the unpatched kernel, the repro triggers the bug in less than a
minute.


-- 
Thanks and Regards,

Dipanjan
