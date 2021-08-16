Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48B263ED9EE
	for <lists+io-uring@lfdr.de>; Mon, 16 Aug 2021 17:35:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233104AbhHPPfs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 Aug 2021 11:35:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232822AbhHPPfr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 Aug 2021 11:35:47 -0400
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C33DC061764
        for <io-uring@vger.kernel.org>; Mon, 16 Aug 2021 08:35:15 -0700 (PDT)
Received: by mail-ot1-x335.google.com with SMTP id c19-20020a9d6153000000b0051829acbfc7so6504226otk.9
        for <io-uring@vger.kernel.org>; Mon, 16 Aug 2021 08:35:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=izwgpX7oSIIBHk0sYhZRSPI0m7nv9ZWnNviimlv3Gso=;
        b=vfpaG8itDkP6v04+k6YoH4XGZJLxHWYS9XMAriNKK//2SkDt3NN7yK1kiF1WfB38UN
         d4zrAaVVkQsDMG0QZjZtQgB9Xb3GgRM8/7fGsQyUR2g5gVveE7FZh0l/S48Ad1yRNKCW
         lDwIkecxFeEy0MLogCx5z1bedl3y7Vkwhzgl1OfUvPMLdnO7MZjWDbBTLFka0Tcf9bBt
         lvRz/oJrh2FEV3vcdUcXjy26++zbEPcOAzwWpZ1jKGn5PmBm2Xa5YzlWExU/4z+wSSap
         GaFGgbrtBGACITtrbzW22viwPxcaM3ykRc2D8strDPLQwOolMlWh+9krFzaq/yRMsRWs
         3cxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=izwgpX7oSIIBHk0sYhZRSPI0m7nv9ZWnNviimlv3Gso=;
        b=DIH+TkmmT3w+EH+05Jif73F+AFe24DSEKupqb870+m7R7F5CjY2SZwYfvIjwzZ0FBu
         z0PGKcKmP7MRtdblMDn5plclJsYbVEGGA0sQOtDvmxqEC8cRnh/oOOhbn73zBXU5uECf
         xzyGE0PZNtSrmovE5HB3wLYXHNB5UJqt3yY+nZYIUxWY9gvu1ZAp5rP/p4Nu7nvYeilE
         aSsMHdfUQUBPXy3JbMPCFtiR6xP3sBonIL3lVOw22DnRNpO6Zth45SqihVFPUtYMA+6u
         fTxCdy4cd+ar2Q+PCUsBgTAbmqN1ca8Lfft77xT6l1ixxU+EY5sRo7TYM2BLr3Oph5uV
         b9/g==
X-Gm-Message-State: AOAM531AEey7Nvi/gue6LfE1rlD5oy2+cR+k5ig2njR7xMaqrCvXzRVv
        4Md+147BFGWLzEQVGww8pe3sBw==
X-Google-Smtp-Source: ABdhPJxNBT6VQqF+a/LrmpscGhFK1PmHsr1ZBxcAfX5odX2+MffbpKSANyXAwOgf8nofz4cDBJlACg==
X-Received: by 2002:a05:6830:1289:: with SMTP id z9mr3770498otp.28.1629128114671;
        Mon, 16 Aug 2021 08:35:14 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id k13sm2121887oik.40.2021.08.16.08.35.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Aug 2021 08:35:14 -0700 (PDT)
Subject: Re: [PATCH v2 0/2] iter revert problems
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Cc:     Palash Oswal <oswalpalash@gmail.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        linux-kernel@vger.kernel.org,
        syzbot+9671693590ef5aad8953@syzkaller.appspotmail.com
References: <cover.1628780390.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <221d06f1-7e6b-c48f-57e8-45111c979217@kernel.dk>
Date:   Mon, 16 Aug 2021 09:35:12 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1628780390.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/12/21 2:40 PM, Pavel Begunkov wrote:
> For the bug description see 2/2. As mentioned there the current problems
> is because of generic_write_checks(), but there was also a similar case
> fixed in 5.12, which should have been triggerable by normal
> write(2)/read(2) and others.
> 
> It may be better to enforce reexpands as a long term solution, but for
> now this patchset is quickier and easier to backport.
> 
> v2: don't fail it has been justly fully reverted

Al, what do you think of this approach? It'll fix the issue, but might be
cleaner to have iov->truncated actually track the truncated size. That'd
make it a more complete solution, at the expense of bloat iov_iter which
this version will not.

-- 
Jens Axboe

