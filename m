Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53765536A21
	for <lists+io-uring@lfdr.de>; Sat, 28 May 2022 04:14:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352312AbiE1COZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 27 May 2022 22:14:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiE1COY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 27 May 2022 22:14:24 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD8C6633BD
        for <io-uring@vger.kernel.org>; Fri, 27 May 2022 19:14:23 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id q4so5600826plr.11
        for <io-uring@vger.kernel.org>; Fri, 27 May 2022 19:14:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=Na8hMEY8lBHm6RSzcTnwQathpiBPKq8T6QIyfb00CFQ=;
        b=G7pQ4KgZNMhy6mVPcezN4s7eyrFGLGAIynIqJ4TxRMNlIqY1QB2AzzVCXxb5sD8/w6
         PduW7++9xzBiX0rfo76jETUftpuXp+F/BXjRRa4C0QCluUJ5dcqRGUMn2GFGrIvDO1t/
         RQGH/jOBhtmOJcRt9rX45iJmcfaiy55Y9UdfaXUhfr0oChU83HOYTMjhiKpnKuclWJMR
         JegVMCZocK/peupZc6pnTWFHYOn1yperFiYN8SbGrxLzS4nwOR1m5YU2DVHXym157HEs
         niC1DjD3v5Zin3B5SAtG+I9QGWLdQAwTwse/CRMTEyBjfyPfcqJGNNiS0zt7kCA8/iCW
         WxCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=Na8hMEY8lBHm6RSzcTnwQathpiBPKq8T6QIyfb00CFQ=;
        b=arR1OUWJLBmNdkwR6CsCJ6dfU5APp3FtzFYdv2zxKhuHm9X7xsMow2aEOQE0vLxtI4
         zIc34lok9FQ++Mj/UYijJl04O5AlhKgNrMlwjACzlP+rGJjSh/mj2WYVmyA8DgOqvq/R
         Eai1df3+e/Gm9o4x1U4g4OcV7dUT+pGQul6dFqdcNxQ2jQMHbFctpfYy29LCPfH8hzIP
         BFILSWFgmh3OYmDZ8ROf4p6Zj6zeqBAExUXZKiuhal1nJlbJylsTvHTSdF0V5gY7FKeX
         Ij4gYFnPXTtN/ApOX4dCsWqmFLbwQ2B6rxcgfa9LyJ9/C9I+JkpqEngW5Wd26AnvZedH
         oZpA==
X-Gm-Message-State: AOAM530JxJge8+uid2QT7gLNEvcQ9IlfNEiIz6NMqdmVPgwpcSIVj9yC
        H9uIYl0q7OtJB8nbXnCdMtQZ8w==
X-Google-Smtp-Source: ABdhPJyApEQ4pufj4++SCgUTPJNclxe/5FevlyXdDzvfhf1sfQwVQgbq1MXLISxKz4CFbIKuG4T9Gg==
X-Received: by 2002:a17:90a:4615:b0:1df:40e6:6474 with SMTP id w21-20020a17090a461500b001df40e66474mr11543903pjg.194.1653704063314;
        Fri, 27 May 2022 19:14:23 -0700 (PDT)
Received: from [127.0.1.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id p10-20020a170902ebca00b00161ac982b52sm4397555plg.95.2022.05.27.19.14.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 May 2022 19:14:22 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     xiaoguang.wang@linux.alibaba.com, io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
In-Reply-To: <20220528015109.48039-1-xiaoguang.wang@linux.alibaba.com>
References: <587a9737-9979-302e-4484-dfdbebe29d78@kernel.dk> <20220528015109.48039-1-xiaoguang.wang@linux.alibaba.com>
Subject: Re: [PATCH v3] io_uring: defer alloc_hint update to io_file_bitmap_set()
Message-Id: <165370406243.574042.17161014772371599664.b4-ty@kernel.dk>
Date:   Fri, 27 May 2022 20:14:22 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, 28 May 2022 09:51:09 +0800, Xiaoguang Wang wrote:
> io_file_bitmap_get() returns a free bitmap slot, but if it isn't
> used later, such as io_queue_rsrc_removal() returns error, in this
> case, we should not update alloc_hint at all, which still should
> be considered as a valid candidate for next io_file_bitmap_get()
> calls.
> 
> To fix this issue, only update alloc_hint in io_file_bitmap_set().
> 
> [...]

Applied, thanks!

[1/1] io_uring: defer alloc_hint update to io_file_bitmap_set()
      commit: e2d547c6e3caa4b6278bcb30686e1faf6777b3f6

Best regards,
-- 
Jens Axboe


