Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B4CA667A4E
	for <lists+io-uring@lfdr.de>; Thu, 12 Jan 2023 17:06:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233842AbjALQGX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 Jan 2023 11:06:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232398AbjALQF7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 Jan 2023 11:05:59 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E08E5F51;
        Thu, 12 Jan 2023 07:57:26 -0800 (PST)
Received: from localhost.localdomain (unknown [182.253.183.184])
        by gnuweeb.org (Postfix) with ESMTPSA id CA16B7E3C3;
        Thu, 12 Jan 2023 15:57:22 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1673539045;
        bh=D7CklgKgJs2Oydmin9qwbjCd+vetbLK0Jx9DpaoIbvU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lL6Ofjip9z8ukFTSnfNprKPB1bG5VNc3JH8auXBNUeK5vrVAo7RL3+EaiokXOVMYC
         puh+vzx4+DQoMl/FWAhsW+eNLUPXt63zAof3s78dXNpPRMvxF0ZsJWDybEWTdmIo1/
         dsPnMYt+YC2nQ3ahcWAqjrUGWO6yrvctt8E7+aOxwJ0cFeMsD5k3QnMdN8mIgEOKu7
         1leRG5h+KX2wl+PPJCIis38dWh11GjpWWJv08myZ/SqG+vkLrgfDHB2+vfY+/nN5WJ
         hzn00vEb+qEoTFGVrdDBB+i5i4gkfpQmVhCrjBIdXma2e9ZGMV7DNhZMEjA5sFFGP4
         YDANF6ThXn3YQ==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Breno Leitao <leitao@debian.org>,
        Christian Mazakas <christian.mazakas@gmail.com>,
        Gilang Fachrezy <gilang4321@gmail.com>,
        VNLX Kernel Department <kernel@vnlx.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [PATCH liburing v1 2/4] CHANGELOG: Note about --nolibc configure option deprecation
Date:   Thu, 12 Jan 2023 22:57:07 +0700
Message-Id: <20230112155709.303615-3-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230112155709.303615-1-ammar.faizi@intel.com>
References: <20230112155709.303615-1-ammar.faizi@intel.com>
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

Since commit bfb432f4cce5 ("configure: Always enable `CONFIG_NOLIBC` if
the arch is supported"), the --nolibc configure option is deprecated
and has no effect. Plus, building liburing on x86-64, x86, and aarch64
always enables CONFIG_NOLIBC. Note these changes in the CHANGELOG file.

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 CHANGELOG | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/CHANGELOG b/CHANGELOG
index 93c500f..0722aae 100644
--- a/CHANGELOG
+++ b/CHANGELOG
@@ -4,6 +4,8 @@ liburing-2.4 release
 - Add IO_URING_{MAJOR,MINOR,CHECK}_VERSION() macros.
 - FFI support (for non-C/C++ languages integration).
 - Add io_uring_prep_msg_ring_cqe_flags() function.
+- Deprecate --nolibc configure option.
+- CONFIG_NOLIBC is always enabled on x86-64, x86, and aarch64.
 
 liburing-2.3 release
 
-- 
Ammar Faizi

