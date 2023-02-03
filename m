Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A1E468A272
	for <lists+io-uring@lfdr.de>; Fri,  3 Feb 2023 20:03:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231894AbjBCTDf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 3 Feb 2023 14:03:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233008AbjBCTDc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 3 Feb 2023 14:03:32 -0500
Received: from 66-220-144-178.mail-mxout.facebook.com (66-220-144-178.mail-mxout.facebook.com [66.220.144.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF2081E5F6
        for <io-uring@vger.kernel.org>; Fri,  3 Feb 2023 11:03:26 -0800 (PST)
Received: by dev0134.prn3.facebook.com (Postfix, from userid 425415)
        id D50CE6329949; Fri,  3 Feb 2023 11:03:12 -0800 (PST)
From:   Stefan Roesch <shr@devkernel.io>
To:     io-uring@vger.kernel.org, kernel-team@fb.com
Cc:     shr@devkernel.io, axboe@kernel.dk, ammarfaizi2@gnuweeb.org
Subject: [PATCH v6 4/4] liburing: update changelog with new feature
Date:   Fri,  3 Feb 2023 11:03:10 -0800
Message-Id: <20230203190310.2900766-5-shr@devkernel.io>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230203190310.2900766-1-shr@devkernel.io>
References: <20230203190310.2900766-1-shr@devkernel.io>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,RDNS_DYNAMIC,
        SPF_HELO_PASS,SPF_NEUTRAL,TVD_RCVD_IP autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add a new entry to the changelog file for the napi busy poll feature.

Signed-off-by: Stefan Roesch <shr@devkernel.io>
---
 CHANGELOG | 1 +
 1 file changed, 1 insertion(+)

diff --git a/CHANGELOG b/CHANGELOG
index 0722aae..7810137 100644
--- a/CHANGELOG
+++ b/CHANGELOG
@@ -6,6 +6,7 @@ liburing-2.4 release
 - Add io_uring_prep_msg_ring_cqe_flags() function.
 - Deprecate --nolibc configure option.
 - CONFIG_NOLIBC is always enabled on x86-64, x86, and aarch64.
+- Support for napi busy polling
=20
 liburing-2.3 release
=20
--=20
2.30.2

