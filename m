Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD7AD736B08
	for <lists+io-uring@lfdr.de>; Tue, 20 Jun 2023 13:32:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230413AbjFTLcm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 20 Jun 2023 07:32:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjFTLcm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 20 Jun 2023 07:32:42 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 456D3FE
        for <io-uring@vger.kernel.org>; Tue, 20 Jun 2023 04:32:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=97Z1tbXEi81iwK11sb9zlbPrGxeNKyR5BT0VqrVO1xo=; b=peBa/21ahoVER5WSnoG5imd4PF
        Z677r/PnT5QjZ8e7r8D4mo2HVeYxNgGSpf13RtORf8K//sM3N0gWcShl2j3+NNxLIth/C5f8Icvw0
        Udhl4t+50oMmGr9pLIkKB9oV/ONrH4kux7sWv4PvzD2vYKfVHnTy0blP6gMC70+dMLbWaLcvycz2B
        h688b3XF5ssqK++gEw20BOFaFhSW3YdiVmoayJpIgD2eRN42eQZH14xDMyM5k3ISOmIL8h9RL+iYi
        AdwlKBOvuk5N+3QV1jocYjvZoDcep141JNlgF8rw3zcCbn7PUB20V+oqSHfno1v/sBySl97TKkKto
        NTDONmJA==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qBZbD-00B8WC-2b;
        Tue, 20 Jun 2023 11:32:40 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Subject: io_uring req flags cleanups
Date:   Tue, 20 Jun 2023 13:32:27 +0200
Message-Id: <20230620113235.920399-1-hch@lst.de>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Jens,

while looking at the NOWAIT flag handling I found various bits of code
related to it pretty convoluted and confusing.  This series tries to
clean them up, let me know what you think.

Diffstat:
 cancel.c    |    5 +----
 filetable.c |   11 ++++-------
 filetable.h |   28 +++++++++++++++++-----------
 io_uring.c  |   41 ++++++++++-------------------------------
 io_uring.h  |    5 -----
 msg_ring.c  |    4 +---
 rsrc.c      |    8 ++++----
 rw.c        |    4 ++--
 8 files changed, 39 insertions(+), 67 deletions(-)
