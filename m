Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E36445FEE6
	for <lists+io-uring@lfdr.de>; Sat, 27 Nov 2021 14:44:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355113AbhK0Nrj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 27 Nov 2021 08:47:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351286AbhK0Npi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 27 Nov 2021 08:45:38 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CCDEC061758
        for <io-uring@vger.kernel.org>; Sat, 27 Nov 2021 05:41:49 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id v23so14917652iom.12
        for <io-uring@vger.kernel.org>; Sat, 27 Nov 2021 05:41:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:in-reply-to:references:subject:message-id:date:mime-version
         :content-transfer-encoding;
        bh=xXFdK9mEptTHz6eoVHHWEZw7HjC/F4jPtycZhIGLmPc=;
        b=YG4K0jfRf0aZOk0n93U7Yiry4DdIqoGNv6AjAGGT1FjXy+6y8F6a2jxxLi4Z4y7zd4
         HvJ+9R7u8gYhp18RlRS5R+isJ4Z9sxxNI7rZ4oTLIjqrN8MTQ/EFTxX3eyjHX3hZs8iY
         me2UqvIQWgE+5ZJfuAIjVuS0rtvfZXeycLQeu9TNLv0ZWjTBvYpDPmLNIN2ke++92Thc
         tGJ88taFCen5uv/cvWihoQE89Rwg0hybrGapuTnIcfnhmmZQbIzt2gawPdjgeVXnxTFi
         0B5smoRNeqBpqipoAI6Ca/+e07N98jEQOfIK6I+Y3y/FfSIJx2p1/UI8d6WHe8ZeT+2w
         W5Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=xXFdK9mEptTHz6eoVHHWEZw7HjC/F4jPtycZhIGLmPc=;
        b=B8p1+2Q5cUx81a4/QgXXyzk9ju9SYUeUL8fVJM+fjvE19wodYGESFo7VyxseqZ8Z8l
         etN/niGCPIgyNyCvtLdTU2A93nlGNBtd3ghQPHYeeL1RlemxtYraaj6w1hcQZrbpAxsY
         c4CSefvNd6Own7NMBW/b+lRba5sT1TAQlvrRADaLISTQ6ZSmfntVeoCZRi9mx2cjQYzu
         JT3BCsTyLc/UsCOKAEYSYXqNNkV1H3S7D9AdRPW4xKVX5aRBnzzSuXcf9HDCgi5TxAZC
         GMk4pgz90D2faA+3GcWkjqlQWDBeD/eURFTm1L1MBIN3yd1Fjo4t2TUDXciSlsrQJF4V
         Zi0A==
X-Gm-Message-State: AOAM5335aAPtIMfRLHIrD7q5XpFiz1xbc/s8chCxl2y/Z2yw/xDzMXAG
        z/UkKRNLqB2yF/SPq0DP//yzOg==
X-Google-Smtp-Source: ABdhPJyZokGlQ9AHSuYYIR8BH4cuewT/e89oogcwqd3c4BCLVreEWcUNMJRPazGujyB1l6L0K26C5g==
X-Received: by 2002:a05:6638:3048:: with SMTP id u8mr37259280jak.148.1638020509019;
        Sat, 27 Nov 2021 05:41:49 -0800 (PST)
Received: from [127.0.1.1] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id m12sm5859718iow.54.2021.11.27.05.41.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Nov 2021 05:41:48 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, asml.silence@gmail.com,
        Ye Bin <yebin10@huawei.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20211118015907.844807-1-yebin10@huawei.com>
References: <20211118015907.844807-1-yebin10@huawei.com>
Subject: Re: [PATCH -next] io_uring: Fix undefined-behaviour in io_issue_sqe
Message-Id: <163802050825.624396.15004136636367239529.b4-ty@kernel.dk>
Date:   Sat, 27 Nov 2021 06:41:48 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, 18 Nov 2021 09:59:07 +0800, Ye Bin wrote:
> We got issue as follows:
> ================================================================================
> UBSAN: Undefined behaviour in ./include/linux/ktime.h:42:14
> signed integer overflow:
> -4966321760114568020 * 1000000000 cannot be represented in type 'long long int'
> CPU: 1 PID: 2186 Comm: syz-executor.2 Not tainted 4.19.90+ #12
> Hardware name: linux,dummy-virt (DT)
> Call trace:
>  dump_backtrace+0x0/0x3f0 arch/arm64/kernel/time.c:78
>  show_stack+0x28/0x38 arch/arm64/kernel/traps.c:158
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x170/0x1dc lib/dump_stack.c:118
>  ubsan_epilogue+0x18/0xb4 lib/ubsan.c:161
>  handle_overflow+0x188/0x1dc lib/ubsan.c:192
>  __ubsan_handle_mul_overflow+0x34/0x44 lib/ubsan.c:213
>  ktime_set include/linux/ktime.h:42 [inline]
>  timespec64_to_ktime include/linux/ktime.h:78 [inline]
>  io_timeout fs/io_uring.c:5153 [inline]
>  io_issue_sqe+0x42c8/0x4550 fs/io_uring.c:5599
>  __io_queue_sqe+0x1b0/0xbc0 fs/io_uring.c:5988
>  io_queue_sqe+0x1ac/0x248 fs/io_uring.c:6067
>  io_submit_sqe fs/io_uring.c:6137 [inline]
>  io_submit_sqes+0xed8/0x1c88 fs/io_uring.c:6331
>  __do_sys_io_uring_enter fs/io_uring.c:8170 [inline]
>  __se_sys_io_uring_enter fs/io_uring.c:8129 [inline]
>  __arm64_sys_io_uring_enter+0x490/0x980 fs/io_uring.c:8129
>  invoke_syscall arch/arm64/kernel/syscall.c:53 [inline]
>  el0_svc_common+0x374/0x570 arch/arm64/kernel/syscall.c:121
>  el0_svc_handler+0x190/0x260 arch/arm64/kernel/syscall.c:190
>  el0_svc+0x10/0x218 arch/arm64/kernel/entry.S:1017
> ================================================================================
> 
> [...]

Applied, thanks!

[1/1] io_uring: Fix undefined-behaviour in io_issue_sqe
      commit: f6223ff799666235a80d05f8137b73e5580077b9

Best regards,
-- 
Jens Axboe


