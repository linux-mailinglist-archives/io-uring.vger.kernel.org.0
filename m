Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91EE86BD3F7
	for <lists+io-uring@lfdr.de>; Thu, 16 Mar 2023 16:37:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231765AbjCPPhy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Mar 2023 11:37:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231767AbjCPPhe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Mar 2023 11:37:34 -0400
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45CCDDCA4D
        for <io-uring@vger.kernel.org>; Thu, 16 Mar 2023 08:35:23 -0700 (PDT)
Received: by mail-io1-f49.google.com with SMTP id o12so962751iow.6
        for <io-uring@vger.kernel.org>; Thu, 16 Mar 2023 08:35:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1678980753; x=1681572753;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Sin8LWNwd+gSsssO+bPOjSMnz5XN2DTMMP/VA38vFQk=;
        b=4Dn/TNPAo+ZlyNMy9gLn6QQk5Hf+d5ugNuRPcuHhiWTAPuMPAkDEc7hUTpox0yRvG3
         MU9T3IjeYj4cebPQg0XDU+ptqDVaBcQKuWYcri8tbQapsrtTr4TSZEhbxBXSpSW8ek66
         qiLXq50hpFLc6657fRoFnvkv4LELjE8usegOeA4CjRctAOCVlJTi5DlngAhUU5ivNonu
         hyEl8th46n5Zyeg41h+LhlISdnKdesfQ1MswCkJK0PVzHvuay70AE7x7221yCaMdjB8u
         JIeplJIK2r2O0CaYAsjkMO2DkmSMsT+Cpz/RXEb55QOR/WatvSe79/CpvhqjSOF+CWTR
         luRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678980753; x=1681572753;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Sin8LWNwd+gSsssO+bPOjSMnz5XN2DTMMP/VA38vFQk=;
        b=W3ponIaI2kCTUC01/qbVLaFNvnLOooqRDI9RqQj0vMYtnGdUwTEbHLm6b5Y9CNr0C8
         8iG4J5xJ1jbRRAYFq3v/6bzCNxRmL1Et//pO0ovrDtXSRSNV7e2YNrQGWBt+T/cOLqPc
         3ccuwrGaHgyBUzYs1xm61qk5haJ7O+V1HBB/qS5CjyreEwJz9Sz8QNqQTHyO0T1PvL8X
         KNzKqoXR87r0y9XqRb97gocmbMc37kqS7SP3CgBUAkca144E+rwbM1oNtjJmRrJShHOR
         r2bKnuy6XTF9pk6V0kSO7oAMAexkT/+iY6kdHoXX22bXnXzCuvYL2xjq4iKyqWJf6jKd
         ahOg==
X-Gm-Message-State: AO0yUKWPGL3uNOEiEDDn0PEC2OUwCibdmEu09XyfiAnf0n1NiRY9B+Nd
        Rs4SLVfa88C8Soi2UpB+PgdAeJ/disrHZ1xeeDu5Kg==
X-Google-Smtp-Source: AK7set/8vMTHF4dkLLTMVZVLWLrWV8FI6eBXRYMyAHZQZLlDB9nVr2Oe9m7ZD2gjB3UjO07aUKgMBg==
X-Received: by 2002:a6b:c38f:0:b0:752:f9b6:386b with SMTP id t137-20020a6bc38f000000b00752f9b6386bmr1762622iof.0.1678980753355;
        Thu, 16 Mar 2023 08:32:33 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id a3-20020a029983000000b003c4e02148e5sm2541290jal.53.2023.03.16.08.32.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 08:32:32 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Cc:     Mark Rutland <mark.rutland@arm.com>
In-Reply-To: <10efd5507d6d1f05ea0f3c601830e08767e189bd.1678980230.git.asml.silence@gmail.com>
References: <10efd5507d6d1f05ea0f3c601830e08767e189bd.1678980230.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] io_uring/rsrc: fix folly accounting
Message-Id: <167898075271.29101.7596458728573428968.b4-ty@kernel.dk>
Date:   Thu, 16 Mar 2023 09:32:32 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-2eb1a
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On Thu, 16 Mar 2023 15:26:05 +0000, Pavel Begunkov wrote:
> | BUG: Bad page state in process kworker/u8:0  pfn:5c001
> | page:00000000bfda61c8 refcount:0 mapcount:0 mapping:0000000000000000 index:0x20001 pfn:0x5c001
> | head:0000000011409842 order:9 entire_mapcount:0 nr_pages_mapped:0 pincount:1
> | anon flags: 0x3fffc00000b0004(uptodate|head|mappedtodisk|swapbacked|node=0|zone=0|lastcpupid=0xffff)
> | raw: 03fffc0000000000 fffffc0000700001 ffffffff00700903 0000000100000000
> | raw: 0000000000000200 0000000000000000 00000000ffffffff 0000000000000000
> | head: 03fffc00000b0004 dead000000000100 dead000000000122 ffff00000a809dc1
> | head: 0000000000020000 0000000000000000 00000000ffffffff 0000000000000000
> | page dumped because: nonzero pincount
> | CPU: 3 PID: 9 Comm: kworker/u8:0 Not tainted 6.3.0-rc2-00001-gc6811bf0cd87 #1
> | Hardware name: linux,dummy-virt (DT)
> | Workqueue: events_unbound io_ring_exit_work
> | Call trace:
> |  dump_backtrace+0x13c/0x208
> |  show_stack+0x34/0x58
> |  dump_stack_lvl+0x150/0x1a8
> |  dump_stack+0x20/0x30
> |  bad_page+0xec/0x238
> |  free_tail_pages_check+0x280/0x350
> |  free_pcp_prepare+0x60c/0x830
> |  free_unref_page+0x50/0x498
> |  free_compound_page+0xcc/0x100
> |  free_transhuge_page+0x1f0/0x2b8
> |  destroy_large_folio+0x80/0xc8
> |  __folio_put+0xc4/0xf8
> |  gup_put_folio+0xd0/0x250
> |  unpin_user_page+0xcc/0x128
> |  io_buffer_unmap+0xec/0x2c0
> |  __io_sqe_buffers_unregister+0xa4/0x1e0
> |  io_ring_exit_work+0x68c/0x1188
> |  process_one_work+0x91c/0x1a58
> |  worker_thread+0x48c/0xe30
> |  kthread+0x278/0x2f0
> |  ret_from_fork+0x10/0x20
> 
> [...]

Applied, thanks!

[1/1] io_uring/rsrc: fix folly accounting
      commit: d2acf789088bb562cea342b6a24e646df4d47839

Best regards,
-- 
Jens Axboe



