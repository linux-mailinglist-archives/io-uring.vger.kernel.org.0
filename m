Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E5216C3FA5
	for <lists+io-uring@lfdr.de>; Wed, 22 Mar 2023 02:17:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229487AbjCVBRn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 21 Mar 2023 21:17:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbjCVBRj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 21 Mar 2023 21:17:39 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 947095A1B6
        for <io-uring@vger.kernel.org>; Tue, 21 Mar 2023 18:17:22 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id B0CBD22B8E;
        Wed, 22 Mar 2023 01:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1679447794; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=908oAxWG5c6NRPonKtfHIznCA8X9Male0yNTgjvxs5I=;
        b=otXLzRGpCfMEHbrRyc4k15ve6bwGGdgiMCQyuHVUr3TM6C1N9u6JH6GGNEGM2bDk4lXfl4
        OYoVeDBmjhe5cgjCh7awatotzcMSKLDg5fS5inzFmC4Qs6WRd2BcaFezmgk3iyeeI94GNa
        wxXzVCjZkiqcJ7+ZXrCwxFqsNdINlhA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1679447794;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=908oAxWG5c6NRPonKtfHIznCA8X9Male0yNTgjvxs5I=;
        b=siTokWxaOTRnFNc+BUbciIGHQQzSAF4IXrWsQJ9mqruHh3EWoD8jEhzafvHo9OvVmNm6O8
        bJyuKnbsM1OiQHAQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3E42313451;
        Wed, 22 Mar 2023 01:16:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id GeKRN/FWGmQ4fQAAMHmgww
        (envelope-from <krisman@suse.de>); Wed, 22 Mar 2023 01:16:33 +0000
From:   Gabriel Krisman Bertazi <krisman@suse.de>
To:     axboe@kernel.dk
Cc:     io-uring@vger.kernel.org, Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH 0/2] io-wq: cleanup io_wq and io_wqe
Date:   Tue, 21 Mar 2023 22:16:26 -0300
Message-Id: <20230322011628.23359-1-krisman@suse.de>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Jens,

This tides up the io-wq internal interface by dropping the io_wqe/io_wq
separation, which no longer makes sense since commit
0654b05e7e65 ("io_uring: One wqe per wq").  We currently have a single
io_wqe instance per io_wq, which is embedded in the structure.  This
patchset merges the two, dropping bit of code to go from one to the
other in the io-wq implementation.

I don't expect it to have any positive impact on performance, of course,
since hopefully the compiler optimizes it, but still, it is nice clean
up.  To be sure, I measured with some mmtests microbenchmarks and I haven't
seen differences with or without the patchset.

Patch 2 is slightly big to review but the use of wq and wqe is
intrinsically connected; it was a bit hard to break it in more pieces.

Tested by running liburing's testsuite and mmtests performance
microbenchmarks (which uses fio).

Based on your for-next branch.

Thanks,

Gabriel Krisman Bertazi (2):
  io-wq: Move wq accounting to io_wq
  io-wq: Drop struct io_wqe

 io_uring/io-wq.c | 408 ++++++++++++++++++++++-------------------------
 1 file changed, 189 insertions(+), 219 deletions(-)

-- 
2.35.3

