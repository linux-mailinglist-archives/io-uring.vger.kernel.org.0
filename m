Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BE74416A1B
	for <lists+io-uring@lfdr.de>; Fri, 24 Sep 2021 04:43:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243954AbhIXCpV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Sep 2021 22:45:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243947AbhIXCpV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Sep 2021 22:45:21 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B60B2C061756
        for <io-uring@vger.kernel.org>; Thu, 23 Sep 2021 19:43:48 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id p80so10709167iod.10
        for <io-uring@vger.kernel.org>; Thu, 23 Sep 2021 19:43:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=jNFV9KO3ralVqp4Wd7niMG35JvXLR+iQVqVzf0CGirI=;
        b=EGG4MHj7Tiz5rEQ1HlKdAihTpb0A5zbW1OrHw3V7x/bkzVTOOMHwWjiuHCegqIaEWs
         jPO+9PrqiDaGXDtQdYRA4B3INAh3MCXa4x+bkxNGebhcAPgOu3aeSy2vORxq9J5DWvd7
         bL14awuetbiijQqKQxiA2zk2C7eHsC0w4Rvh8Y2fcg/XqqbrweBIvsSfnotfOKtZqJax
         G1AsMniQi+y2ni1hSbDOeNQ0gwIWaPCrHmA9Wcb3cDxEafDeQV0whahVvP/zp1ABVVwR
         iUDrBejLtbM24OWeW/XkTYNbTfEOzV0x6pkpGE3wPr7Fmi2Z+d7BT7WoFNAkzrtsDyK5
         FXtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jNFV9KO3ralVqp4Wd7niMG35JvXLR+iQVqVzf0CGirI=;
        b=fVCcg2OoqWkF595HcFdbte/7wBXSNS8Mb3jq0jRh+BaFJoyUyl52Shg4BhIh7pmAmJ
         8/kzaiREZHwtGtJ4WoiTeAhr6bP0RhdWiymWB6lThxeW/aRm6laZB3d+7bhzlg+ArQ3N
         lufaZyek14f9lWyiaoD6GydAHAeAErVZZL0itMSnX5AtW4aFgwXcuD+B6zS+mX2lDK9o
         WMML902eCpXUDeBJA97SrUAYVc7sbzXOj5+nz0iCYlab6VHiD8KnGOOVYzl4qVYxjsiZ
         SGx/xIBQXhon1XYjp8aREtIXybnwhOy+tjVVVzci1kg2g81+6UVdWsPC0jinEQ9ggR5i
         MEMg==
X-Gm-Message-State: AOAM531cVY9nCDQ9Bw2WXWznRpgmGPMxuukihvTmdv5cR3PVPa0LLh22
        Xfg/OaaSd3EgpwIGW1kGB82Dp/9dppk/6A==
X-Google-Smtp-Source: ABdhPJw0TxbQoYO6X2WauMDduwfWqOIN9yQ5KvcohyP1JVEiIGwBqiwoB0SI7LkCGgoyJxtMJbyWMw==
X-Received: by 2002:a5d:9c0a:: with SMTP id 10mr768337ioe.76.1632451427745;
        Thu, 23 Sep 2021 19:43:47 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id v17sm3437970ilh.67.2021.09.23.19.43.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Sep 2021 19:43:46 -0700 (PDT)
Subject: Re: [syzbot] INFO: task hung in io_uring_del_tctx_node
To:     syzbot <syzbot+111d2a03f51f5ae73775@syzkaller.appspotmail.com>,
        asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <00000000000064b6b405ccb41113@google.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <5b3f8081-fbdd-ea2c-eddb-292d02be98a8@kernel.dk>
Date:   Thu, 23 Sep 2021 20:43:45 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <00000000000064b6b405ccb41113@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/23/21 7:57 PM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    92477dd1faa6 Merge tag 's390-5.15-ebpf-jit-fixes' of git:/..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=1471785b300000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=e917f3dfc452c977
> dashboard link: https://syzkaller.appspot.com/bug?extid=111d2a03f51f5ae73775
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1511c4f7300000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=132d1d1d300000


diff --git a/fs/io_uring.c b/fs/io_uring.c
index fe5e613b960f..efb244deb081 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -9636,8 +9641,10 @@ static void io_uring_clean_tctx(struct io_uring_task *tctx)
 	struct io_tctx_node *node;
 	unsigned long index;
 
-	xa_for_each(&tctx->xa, index, node)
+	xa_for_each(&tctx->xa, index, node) {
 		io_uring_del_tctx_node(index);
+		cond_resched();
+	}
 	if (wq) {
 		/*
 		 * Must be after io_uring_del_task_file() (removes nodes under

-- 
Jens Axboe

