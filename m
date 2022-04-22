Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B52850C122
	for <lists+io-uring@lfdr.de>; Fri, 22 Apr 2022 23:36:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230004AbiDVVi0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 Apr 2022 17:38:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230036AbiDVViQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 Apr 2022 17:38:16 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD7FB409D05
        for <io-uring@vger.kernel.org>; Fri, 22 Apr 2022 13:42:38 -0700 (PDT)
Received: from integral2.. (unknown [36.72.214.135])
        by gnuweeb.org (Postfix) with ESMTPSA id 86CEC7E383;
        Fri, 22 Apr 2022 20:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1650659769;
        bh=LniekwLU2MTL37GbO0JaBowiYom1TPZxI2BmilYcIP0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rjn0PUcUoVWsR0wh+uCsLauDQOie7lV4fvQOA6kuj5MTs5knntrmCq12EGgoErZgP
         lDkMezpw9Q71k0+31rNLnyOYgdvGkiUCBv0kqQoxraKLsAx0bIdVL69ZPqL12KF5iD
         Wn6dlYKr3dmGmYNzZ13gtbP1Eg8exfnmVEWk3N6s4Nz6NTjC9nje9+ibxxvNmTWeYi
         xtCgcI55QifJAWZzKJc6oU3SqhQuAwRugM4+cOkyLXr1gd7pKym+fLZxo+hf0oGm2A
         A9V5EY3F4S7+7Ce61xGSVpPMebEyg5qjg1yKWRf8cgEDINWjOcSw+cVgrzo1S/ZQsF
         tVw4HeWxXAK/A==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [PATCH liburing v1 3/6] test/Makefile: Remove `.PHONY` variable
Date:   Sat, 23 Apr 2022 03:35:39 +0700
Message-Id: <20220422203340.682723-4-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220422203340.682723-1-ammar.faizi@intel.com>
References: <20220422203340.682723-1-ammar.faizi@intel.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=588; h=from:subject:message-id; bh=owlGiXbfXTYip+h6t11B7y5e55Fq+5CymUOxBNk7Tao=; b=owEBbQGS/pANAwAKATZPujT/FwpLAcsmYgBiYxFsI0WlYPvBOT/UhXPIrBH+hlZOclhaTeopBkV9 gbKDCx2JATMEAAEKAB0WIQTok3JtyOTA3juiAQc2T7o0/xcKSwUCYmMRbAAKCRA2T7o0/xcKS+KcB/ 4hz6ddVVvA11GDmDAntExi3p+renBPXZ+VoENBn9neWsBeUSY1H97sjQqAgNxIcr4HCkEV++GO5hSb pFsWn8zrKhin+r7tf27H+MtVd7hGaNcF1OxIySpWUu+/Y3KCociZBE549GklMyGMuTjieVyuY93Qjm ZsA4N2iEqLhHidkZcLuB2MJXvObaa77wxOTvvdmrlZ9nsOgA23BgoGX4jF7HC+9nBvv6aI/MiJc5YG J1TKdSe617Dx+4JdkT+H6le79DFJWxmg+3zPh/KpVMZgLOPoBO/COzfWr9Y6dTrUjAZvo8+MbQ7cvd kbqZl+YqPHIGrW6HpRLCaTX99M2DsQ
X-Developer-Key: i=ammarfaizi2@gnuweeb.org; a=openpgp; fpr=E893726DC8E4C0DE3BA20107364FBA34FF170A4B
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

What we want is a .PHONY build target that depends on runtests-parallel,
not a .PHONY variable. This variable doesn't do anything. Remove it.

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 test/Makefile | 1 -
 1 file changed, 1 deletion(-)

diff --git a/test/Makefile b/test/Makefile
index fe35ff9..444c749 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -237,4 +237,3 @@ runtests-parallel: $(run_test_targets)
 	@echo "All tests passed"
 
 .PHONY: all install clean runtests runtests-loop runtests-parallel
-.PHONY += $(run_test_targets)
-- 
Ammar Faizi

