Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CAC07B990E
	for <lists+io-uring@lfdr.de>; Thu,  5 Oct 2023 02:05:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244174AbjJEAFq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 4 Oct 2023 20:05:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244099AbjJEAFp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 4 Oct 2023 20:05:45 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EB0AD8
        for <io-uring@vger.kernel.org>; Wed,  4 Oct 2023 17:05:41 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id BEE282184B;
        Thu,  5 Oct 2023 00:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1696464339; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=+94kmpWi75IQuJo6TEJXMmOSHiZ1LAuh8zeHZ0Z796Q=;
        b=S0+8Tp2ls/pYguPBWT/fxBaNxOsNOXNqDb2EnB+UX/VA6cNjv29REz8+4GcYbOe6nh6WQM
        uwdrFA7FEWcklnfjRzGJXTqJ1A+qjjiUnN/W6N1+LoISEuLEuWEetiQhteSaD7wt22XJfq
        I/RyL8L0HsiX7p9KQB5/jbxBE/TpZ5E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1696464339;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=+94kmpWi75IQuJo6TEJXMmOSHiZ1LAuh8zeHZ0Z796Q=;
        b=qkq3fPf995ilHoO61HCHtlBr1Kgz0GqESAm28k9Ekuja8wKCoVdkmhMQQNoHMvbx+5Mwxo
        EFamimeTvR+IlOBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 89AE11331E;
        Thu,  5 Oct 2023 00:05:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id j2wNHNP9HWV8DQAAMHmgww
        (envelope-from <krisman@suse.de>); Thu, 05 Oct 2023 00:05:39 +0000
From:   Gabriel Krisman Bertazi <krisman@suse.de>
To:     axboe@kernel.dk
Cc:     io-uring@vger.kernel.org, jmoyer@redhat.com,
        Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH 0/3] trivial fixes and a cleanup of provided buffers
Date:   Wed,  4 Oct 2023 20:05:28 -0400
Message-ID: <20231005000531.30800-1-krisman@suse.de>
X-Mailer: git-send-email 2.42.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Jens,

I'm resubmitting the slab conversion for provided buffers with the
suggestions from Jeff (thanks!) for your consideration, and appended 2
minor fixes related to kbuf in the patchset. Since the patchset grew
from 1 to 3 patches, i pretended it is not a v2 and restart the
counting from 1.

thanks,

Gabriel Krisman Bertazi (3):
  io_uring: Fix check of BID wrapping in provided buffers
  io_uring: Allow the full buffer id space for provided buffers
  io_uring: Use slab for struct io_buffer objects

 include/linux/io_uring_types.h |  2 --
 io_uring/io_uring.c            |  4 ++-
 io_uring/io_uring.h            |  1 +
 io_uring/kbuf.c                | 58 +++++++++++++++++++---------------
 4 files changed, 37 insertions(+), 28 deletions(-)

-- 
2.42.0

