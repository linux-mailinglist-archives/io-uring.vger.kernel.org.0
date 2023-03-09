Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79AB46B2AD7
	for <lists+io-uring@lfdr.de>; Thu,  9 Mar 2023 17:34:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230056AbjCIQeC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Mar 2023 11:34:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230085AbjCIQdd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Mar 2023 11:33:33 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C0C56B307
        for <io-uring@vger.kernel.org>; Thu,  9 Mar 2023 08:25:24 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id h17-20020a17090aea9100b0023739b10792so2504626pjz.1
        for <io-uring@vger.kernel.org>; Thu, 09 Mar 2023 08:25:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1678379123;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3SSe2qq7lJ501I5x11wYPJAMDr/JHWVbyCzR4uPXSPw=;
        b=ChQAgfZ/O2anL0X1XgypOWgdHDGq+/2VrhHYlkEKffcjhU5ADFI2Y1r+BDyzzuN3lw
         wyJpfECpu+4OwokVslpsjiQtq9inTkhkJwLBEmx85Dd2eLbDunNPp0Yk9tyUZm33TzY8
         hFn3g7Py5hkEFCd051bt5IFsOmu5bV6E1l2uJ4DTABUaXnG6WBBELT0erzT1CgTXJx7A
         yDc01hrjgu7OLOvh6VRZKqUPzD/+db9KzEU4Mtbv6p3/kBXBlfNHL7w++d80UJKJWPES
         f6FYgktAiwncmWKzmdgJsNg6/dImVfOyA6K8kLmnbUZJvidHgT0/P56HgXDYdU8Og93K
         a6cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678379123;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3SSe2qq7lJ501I5x11wYPJAMDr/JHWVbyCzR4uPXSPw=;
        b=KNKAyFZqoQzLSOJaRBoeLlsw4CIILm36wdM0GfnT+oFHwGTsZsGSajq/SvhLpSLfYW
         S432y+Jb8lIpxaqah2CT2VQngS5qF7VPK7EyogJcCxdQv+QAg3PcwBrHNM8OGWdaG2vY
         V1ZvlAT9y2Xtuw62I2owlr4jgjQVVhoeoxjvhoO2R0VLty7LbpjzxJLKLl48JkbSRVEN
         1HUF5Oh6Zo54T5qerDEHzIR+3fk1paaa8OVL4sbe4f0WlwM/5kUfGz8LEf9SiySEYhId
         de0NU8HVe6/GR0ahl61FIsIw50XhwniVZWbMkauHw0N91MU7GJxUaO5k7ILyVjYLr/zl
         gqqQ==
X-Gm-Message-State: AO0yUKV1qSV6k6uE/nQZYxFnq6tX5N7ZeNVUb4SR+G15a2XpAQ7LMM42
        9z7TjMcgHNygzPxNG6AmeU4UIQ==
X-Google-Smtp-Source: AK7set+FZp5n1IKkQw+vsmQij+BaVkystKddYL7O0+kfXQp51B+4dUcoN1rHuuAoi9xppNSfrGUFTA==
X-Received: by 2002:a17:903:32c7:b0:19d:2a3:f019 with SMTP id i7-20020a17090332c700b0019d02a3f019mr26227755plr.1.1678379122658;
        Thu, 09 Mar 2023 08:25:22 -0800 (PST)
Received: from [172.20.4.229] ([50.233.106.125])
        by smtp.gmail.com with ESMTPSA id u3-20020a170902e80300b0019a6e8ceb49sm11795403plg.259.2023.03.09.08.25.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Mar 2023 08:25:22 -0800 (PST)
Message-ID: <c719f1e6-35b2-e4c3-7f8b-54e7f0dc0296@kernel.dk>
Date:   Thu, 9 Mar 2023 09:25:10 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH] io_uring/uring_cmd: ensure that device supports IOPOLL
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <CGME20230308163102epcas5p45cc9c1b5b2ab0bcd772c5ff8d72acd93@epcas5p4.samsung.com>
 <2349df76-0acb-0a56-bda1-2cb05aa55151@kernel.dk>
 <20230309092732.GA14977@green5>
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230309092732.GA14977@green5>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/9/23 2:27 AM, Kanchan Joshi wrote:
> On Wed, Mar 08, 2023 at 09:30:56AM -0700, Jens Axboe wrote:
>> It's possible for a file type to support uring commands, but not
>> pollable ones. Hence before issuing one of those, we should check
>> that it is supported and error out upfront if it isn't.
> 
> Indeed, I missed that altogether.
> 
> Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>

FWIW, I changed it a bit so we can fold that check in with the
other IOPOLL section. I added your Reviewed-by still, here's the
v2:

commit 03b3d6be73e81ddb7c2930d942cdd17f4cfd5ba5
Author: Jens Axboe <axboe@kernel.dk>
Date:   Wed Mar 8 09:26:13 2023 -0700

    io_uring/uring_cmd: ensure that device supports IOPOLL
    
    It's possible for a file type to support uring commands, but not
    pollable ones. Hence before issuing one of those, we should check
    that it is supported and error out upfront if it isn't.
    
    Cc: stable@vger.kernel.org
    Fixes: 5756a3a7e713 ("io_uring: add iopoll infrastructure for io_uring_cmd")
    Link: https://github.com/axboe/liburing/issues/816
    Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
    Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 446a189b78b0..2e4c483075d3 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -108,7 +108,7 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
 	struct file *file = req->file;
 	int ret;
 
-	if (!req->file->f_op->uring_cmd)
+	if (!file->f_op->uring_cmd)
 		return -EOPNOTSUPP;
 
 	ret = security_uring_cmd(ioucmd);
@@ -120,6 +120,8 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
 	if (ctx->flags & IORING_SETUP_CQE32)
 		issue_flags |= IO_URING_F_CQE32;
 	if (ctx->flags & IORING_SETUP_IOPOLL) {
+		if (!file->f_op->uring_cmd_iopoll)
+			return -EOPNOTSUPP;
 		issue_flags |= IO_URING_F_IOPOLL;
 		req->iopoll_completed = 0;
 		WRITE_ONCE(ioucmd->cookie, NULL);

-- 
Jens Axboe


