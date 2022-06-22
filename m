Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDC96556E62
	for <lists+io-uring@lfdr.de>; Thu, 23 Jun 2022 00:27:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356284AbiFVW1L (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Jun 2022 18:27:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357635AbiFVW1K (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 22 Jun 2022 18:27:10 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF2573EBBC
        for <io-uring@vger.kernel.org>; Wed, 22 Jun 2022 15:27:09 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id a14so7754557pgh.11
        for <io-uring@vger.kernel.org>; Wed, 22 Jun 2022 15:27:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=F4+5u3XcEw77N1ZRzFWpa5aMMjR09CqNAjzWGInUL04=;
        b=Z6Ch6AFfVYy1aSRHJED6pPk640NCFpxAbmLjHfYo7zsgSTe4c/5JjJ2aV14GtUg36s
         ADCU0WovOe1gRKm6zwVk+dL9L9uefYyLwXK6dPi19UkqZjLBFkOWupqgwZ/ybtgGZX7o
         UYSQ18jslLn/N1epH2N/IyI/O58LBFCQb31RwxUrpK2o55LnWcnrfTxvs6ffP36MUnF5
         Ye5MPb1Es0Qxa/45vBtmJWGf/xLJhA1ONUWU28A69pO6gMWdqL+t9YEG0q6y+bh3Y10+
         N0eCsAGFoqeqqe224VTUWYnB5erbSxBz35j8oK38abWd8BD/IFUP4xuWsB7vXiUfOipU
         sV1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=F4+5u3XcEw77N1ZRzFWpa5aMMjR09CqNAjzWGInUL04=;
        b=DnPTQEOsvSZkQBiCqgxRW0yERhMnfnkIYAT+6GIkgNofisjP0VZ72uB2Fx5zO2PvPo
         bFnNh921+4NotCp/MQWjGN9aqENcJ/AIjHyJyLiwQcfHl6nxcI/yriTC6k+s77gSghAW
         oNE2pxLGWHIQSaItpEOgyYemwPst5qkkvHkSpE9jX1a6BzYGbG2Uh3Qx4ouS72liPb6J
         oQ8NMzmxhfldFAiBPDIrz0yWJ0TqxydATt9ZvFkA6nMrGwGQ2xDlNMv4Ufgs/2rjF+bP
         6yOx33NGQL/M1nSQPLoy82QzPxMn6DZ6QQt3GL2cQ2+q2WWHHyrZbdND4xRN3LN+d0Ix
         ncpQ==
X-Gm-Message-State: AJIora9FLHq3xEQYdI+tMb8h3spFt+3nGa3VYT4URGwykm+zgP6k+9y2
        /mk5yUvC7nCZLIEpVg+xyWoQW/BF2puw3w==
X-Google-Smtp-Source: AGRyM1uw3cY6oXk6i4t5/0Q3RYLhfkSCHBum7pvSV2jFkIkoO4LfbPCTyOMv8Jl4i5urU0xJPHcr/Q==
X-Received: by 2002:a63:7b18:0:b0:40c:9f14:981 with SMTP id w24-20020a637b18000000b0040c9f140981mr4882657pgc.176.1655936829281;
        Wed, 22 Jun 2022 15:27:09 -0700 (PDT)
Received: from [127.0.1.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id mt9-20020a17090b230900b001e0c1044ceasm271352pjb.43.2022.06.22.15.27.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jun 2022 15:27:08 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     linux-mm@kvack.org, kernel-team@fb.com, linux-xfs@vger.kernel.org,
        io-uring@vger.kernel.org, shr@fb.com, linux-fsdevel@vger.kernel.org
Cc:     david@fromorbit.com, hch@infradead.org, jack@suse.cz,
        willy@infradead.org
In-Reply-To: <20220616212221.2024518-1-shr@fb.com>
References: <20220616212221.2024518-1-shr@fb.com>
Subject: Re: [PATCH v9 00/14] io-uring/xfs: support async buffered writes
Message-Id: <165593682792.161026.12974983413174964699.b4-ty@kernel.dk>
Date:   Wed, 22 Jun 2022 16:27:07 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, 16 Jun 2022 14:22:07 -0700, Stefan Roesch wrote:
> This patch series adds support for async buffered writes when using both
> xfs and io-uring. Currently io-uring only supports buffered writes in the
> slow path, by processing them in the io workers. With this patch series it is
> now possible to support buffered writes in the fast path. To be able to use
> the fast path the required pages must be in the page cache, the required locks
> in xfs can be granted immediately and no additional blocks need to be read
> form disk.
> 
> [...]

Applied, thanks!

[01/14] mm: Move starting of background writeback into the main balancing loop
        commit: 29c36351d61fd08a2ed50a8028a7f752401dc88a
[02/14] mm: Move updates of dirty_exceeded into one place
        commit: a3fa4409eec3c094ad632ac1029094e061daf152
[03/14] mm: Add balance_dirty_pages_ratelimited_flags() function
        commit: 407619d2cef3b4d74565999a255a17cf5d559fa4
[04/14] iomap: Add flags parameter to iomap_page_create()
        commit: 49b5cd0830c1e9aa0f9a3717ac11a74ef23b9d4e
[05/14] iomap: Add async buffered write support
        commit: ccb885b4392143cea1bdbd8a0f35f0e6d909b114
[06/14] iomap: Return -EAGAIN from iomap_write_iter()
        commit: f0f9828d64393ea2ce87bd97f033051c8d7a337f
[07/14] fs: Add check for async buffered writes to generic_write_checks
        commit: cba06e23bc664ef419d389f1ed4cee523f468f8f
[08/14] fs: add __remove_file_privs() with flags parameter
        commit: 79d8ac83d6305fd8e996f720f955191e0d8c63b9
[09/14] fs: Split off inode_needs_update_time and __file_update_time
        commit: 1899b196859bac61ad71c3b3916e06de4b65246c
[10/14] fs: Add async write file modification handling.
        commit: 4705f225a56f216a59e09f7c2df16daabb7b4f76
[11/14] io_uring: Add support for async buffered writes
        commit: 6c8bbd82a43a0c7937e3e8e38cf46fcd90e15e68
[12/14] io_uring: Add tracepoint for short writes
        commit: 6c33dae4526ad079af6432aaf76827d0a27a9690
[13/14] xfs: Specify lockmode when calling xfs_ilock_for_iomap()
        commit: ddda2d473df70607bb456c515d984d05bf689790
[14/14] xfs: Add async buffered write support
        commit: e9cfc64a27f7a581b8c5d14da4efccfeae9c63bd

Best regards,
-- 
Jens Axboe


