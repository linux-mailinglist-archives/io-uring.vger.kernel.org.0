Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B87A66AACA
	for <lists+io-uring@lfdr.de>; Sat, 14 Jan 2023 10:56:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230196AbjANJ4I (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 14 Jan 2023 04:56:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230173AbjANJ4G (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 14 Jan 2023 04:56:06 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1B9176B7
        for <io-uring@vger.kernel.org>; Sat, 14 Jan 2023 01:56:00 -0800 (PST)
Received: from localhost.localdomain (unknown [182.253.183.184])
        by gnuweeb.org (Postfix) with ESMTPSA id 30EE47E24D;
        Sat, 14 Jan 2023 09:55:56 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1673690159;
        bh=Bk+y3zCb+VGqpTOZacV5gp542kfL5OASIUJEhF2KBZk=;
        h=From:To:Cc:Subject:Date:From;
        b=qytfyc7kPqRmmib0BE4INAfwb/CIT3H2acyplng/9nViT/lFQNH0hZs8B+kdumtFr
         VdKo99SlZVeV8NweaZSnaCVQsSGG7vAGAoqT5hY9I8Nd4tKPX/VTGho9vM+6D4h92X
         zVLC5h7QRNpOzASvKupbr8m1rAIrVRcD70/afCRtf2fXpjlM9zr2KvGwvVu+/LanHL
         33EE2ugjhVAHbPMnWW/+5yPdrV+ug6g8N3F93XXQgdAEMB1Hi/CnmVWMGgyFP7scJs
         8BlSx/TkGzE4fmCKw9CtMDrLC/Q6r9/+xetB9uPn9hocEkKTkO2qsUTbtBvQ6XJjBU
         BuitchCGit8jw==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Christian Mazakas <christian.mazakas@gmail.com>,
        Gilang Fachrezy <gilang4321@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        VNLX Kernel Department <kernel@vnlx.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [RFC PATCH liburing v1 0/2] Explain how to build liburing and FFI support
Date:   Sat, 14 Jan 2023 16:55:21 +0700
Message-Id: <20230114095523.460879-1-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Ammar Faizi <ammarfaizi2@gnuweeb.org>

Hi Jens,

This is an RFC patchset.

  ## Patch 1
  Tell people how to build liburing.

  ## Patch 2
  Tell people that they should use the FFI variants when they can't use
  'static inline' functions defined in liburing.h.

What do you think?

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---

Ammar Faizi (2):
  README: Explain how to build liburing
  README: Explain about FFI support

 README | 43 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)


base-commit: 19424b0baa5999918701e1972b901b0937331581
-- 
Ammar Faizi

