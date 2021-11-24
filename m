Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A38C45CBF3
	for <lists+io-uring@lfdr.de>; Wed, 24 Nov 2021 19:18:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242011AbhKXSVV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 24 Nov 2021 13:21:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230396AbhKXSVV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 24 Nov 2021 13:21:21 -0500
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA28CC061574
        for <io-uring@vger.kernel.org>; Wed, 24 Nov 2021 10:18:11 -0800 (PST)
Received: by mail-il1-x130.google.com with SMTP id r2so3345741ilb.10
        for <io-uring@vger.kernel.org>; Wed, 24 Nov 2021 10:18:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:in-reply-to:references:subject:message-id:date:mime-version
         :content-transfer-encoding;
        bh=CTzNrMs1VOWfBNKCsPfzvSmYOJVX0vigBxaApO6DJ0U=;
        b=64mOW27W5oomAEGJfWGNIJ+nnr+sKzXo7EQUD0QIHNL/8CIeDFX03rjWondm11SnJS
         oH7UpsVTCqUGqmXw6ThRt0iNjp5rkNlmZOUmPme/CX2Iklk4rFAXjXhky9fvhL7qAKYp
         g5KGtTENpTN0rEaBJsNEB9t0gDn5ZAU4/0FRaJrBWFZ9+Rtc6oC5+l16BEfQqTzYWYrJ
         oN09XFZ41wnmbw3pgu2zqeX2vU08qQXmFrTgCOILmKlbQk3e7IYsIthNP/16YM5gPIQh
         TZv5oYm6EYAuPc6lbLuxmWSFJPo3y/O1A3RtBeqwIm+mXdmu2kBWeizrUBBbW9olWRyH
         segQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=CTzNrMs1VOWfBNKCsPfzvSmYOJVX0vigBxaApO6DJ0U=;
        b=fMs9qdCCzQQngHh5J4O86F6OxLkuvm8+BC4BQmipMpeqK4qoBZoCkgEUVVgSBt6tLF
         0oXrGCOlNIEmcikPqBE2Y8VLVrDysFPK0J1MCZ/jrpVLh4l3TxAJ+QvbzilUFwcZnymH
         +dP8wMLuL2vZOhSZ6zvP8zXeClC7NsTkO6c35LxaR2g4AZUcgfJ6LZti4BiqJatYKoEG
         yW4N0nWR9nhtEfQ+hN0SIynZ7gCzZl611UkdLncsAuKMD4CVdTVDmK/zA1f3IKwnY8Xc
         mLlouu415BBwl8JQSt6/RavrTZZhivXth3FIvnMUFScWy66ZBBaz0zrmnZMUtGdwYHtW
         0ytg==
X-Gm-Message-State: AOAM531a9EeOaC6Hz/CRAPwltXLwvPx0PfLedM0l/Z8LzlsHA5r0VmER
        X34RdVOPSfjO/6SrGHgYbxFUdGoEEa6UWeOM
X-Google-Smtp-Source: ABdhPJw7iotNhLVqwkkbbuhJqDhDOyYtyqVP84efm7nMvD+s6x5KUD8Bi6469vxpJmgZhnRhFfkhfA==
X-Received: by 2002:a05:6e02:17cf:: with SMTP id z15mr14931835ilu.214.1637777890934;
        Wed, 24 Nov 2021 10:18:10 -0800 (PST)
Received: from [127.0.1.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id l17sm286417ilk.22.2021.11.24.10.18.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Nov 2021 10:18:10 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1636559119.git.asml.silence@gmail.com>
References: <cover.1636559119.git.asml.silence@gmail.com>
Subject: Re: [PATCH v2 0/4] allow to skip CQE posting
Message-Id: <163777789036.479228.12615656445425738291.b4-ty@kernel.dk>
Date:   Wed, 24 Nov 2021 11:18:10 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, 10 Nov 2021 15:49:30 +0000, Pavel Begunkov wrote:
> It's expensive enough to post an CQE, and there are other
> reasons to want to ignore them, e.g. for link handling and
> it may just be more convenient for the userspace.
> 
> Try to cover most of the use cases with one flag. The overhead
> is one "if (cqe->flags & IOSQE_CQE_SKIP_SUCCESS)" check per
> requests and a bit bloated req_set_fail(), should be bearable.
> 
> [...]

Applied, thanks!

[1/4] io_uring: clean cqe filling functions
      commit: 913a571affedd17239c4d4ea90c8874b32fc2191
[2/4] io_uring: add option to skip CQE posting
      commit: 04c76b41ca974b508522831441dd7e5b1b59cbb0
[3/4] io_uring: don't spinlock when not posting CQEs
      commit: 3d4aeb9f98058c3bdfef5286e240cf18c50fee89
[4/4] io_uring: disable drain with cqe skip
      commit: 5562a8d71aa32ea27133d8b10406b3dcd57c01a5

Best regards,
-- 
Jens Axboe


