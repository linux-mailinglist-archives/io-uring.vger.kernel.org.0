Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7621652B57C
	for <lists+io-uring@lfdr.de>; Wed, 18 May 2022 11:01:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233384AbiERIkP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 May 2022 04:40:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233321AbiERIkO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 May 2022 04:40:14 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CE2B1078A7
        for <io-uring@vger.kernel.org>; Wed, 18 May 2022 01:40:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=cgUGsqJJq7kbjC09DdbVxKt7jpi4XHK26AUPLdp3Fd4=; b=acw1Q2iQ8aY4bOKu24sQ/DEWIr
        CWE96XJn+Wv09WWe7zDOtqBWtgvvOqBErJlJDhY7ztGhyLYhZDoQktmWP/QtvA1aRzop0F6AUCCHT
        XLTz4K7C+Tt7j3fr7/aUxXX+Zn79VKmIsWeszcpY+v3QNndd5JD1DhNl8yAuDWRqV8+R+oS6bpxgL
        gFTvc32SYOmuJA0fGylP3kkhkbCvDpm9TLieH1HS3R8T4lj58upXPfjQTd1El061kcVMdhfDqJitj
        wwxZsBw9zRtyTNzTSF2GpZVHoNaw5Q0YOUhooWVTv1tfyGCFtiztpaS6yECVCr4+m0YpoVOSqqv9T
        71yPmjHQ==;
Received: from [2001:4bb8:19a:7bdf:8143:492c:c3b:39b6] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nrFE3-000dT3-C9; Wed, 18 May 2022 08:40:11 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     axboe@kernel.dk
Cc:     asml.silence@gmail.com, io-uring@vger.kernel.org
Subject: sparse fixes for io_uring
Date:   Wed, 18 May 2022 10:39:59 +0200
Message-Id: <20220518084005.3255380-1-hch@lst.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Try to make sparse a little more happy.  The poll code is still a major
trainwreck, but that will need more intensive care.


