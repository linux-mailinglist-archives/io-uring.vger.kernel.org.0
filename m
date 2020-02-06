Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D94B9154A05
	for <lists+io-uring@lfdr.de>; Thu,  6 Feb 2020 18:08:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727804AbgBFRIi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 6 Feb 2020 12:08:38 -0500
Received: from hr2.samba.org ([144.76.82.148]:46524 "EHLO hr2.samba.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727702AbgBFRIh (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Thu, 6 Feb 2020 12:08:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-Id:Date:Cc:To:From;
        bh=nwd5gqbaMKX/Z0kYgxzWw/aQyvc2mVa47rCOFXpB2V0=; b=djlYCCJbDvelbk3vm0xxM0ZWNO
        +cai2U85YiUaB/JVHezHVbhlGNVbwubYUF8ltQTzEoeoOObpy7MAgUmIKMUN7U1mxpzOCNEx7Doww
        lCRveRvbIWUmu6wVTS+HqjEOLq6suaNG4vppsRG5mDdn2R4YYEaLSGDIi2rD1oSBtgk6QJfNKG0y+
        EI1op9x/ZIhD/mgKaA1wAKa6kMz/sQ0t/224BERfVaYE5m83806Iq2bKkOtkEzK3xJ/iLwyK4rHax
        DrSfBDkdRldHjndXK4DklidM3HZiGH81kIm8K9/+MUWT2V7AoDZXLv8p+2ImzPwGAEI4SjIzItpr7
        ti+iohdFXG2S2bp4mniQedGtMD/CYwTJTaSa1x5Hx7LDMrYFAnPDpMXxte615aLJ4F4jaPkgFOdgY
        BGDtsvbttwUeOy+VndKZpYSGfLCxrIifk6Q33yfcaSa0Xp4rvoMuRRDjl4cVZuzHI6K3p3HRA7u2H
        DfL+nzdgZUQkktnJCDu8Ek9g;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1izkdn-00075K-Mp; Thu, 06 Feb 2020 17:08:35 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     io-uring@vger.kernel.org
Cc:     Stefan Metzmacher <metze@samba.org>
Subject: [PATCH v1 3/3] liburing.spec move to liburing-0.4
Date:   Thu,  6 Feb 2020 18:07:58 +0100
Message-Id: <20200206170758.29285-3-metze@samba.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200206170758.29285-1-metze@samba.org>
References: <20200206170758.29285-1-metze@samba.org>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 liburing.spec | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/liburing.spec b/liburing.spec
index 9320b01..e8ed815 100644
--- a/liburing.spec
+++ b/liburing.spec
@@ -1,5 +1,5 @@
 Name: liburing
-Version: 0.3
+Version: 0.4
 Release: 1%{?dist}
 Summary: Linux-native io_uring I/O access library
 License: LGPLv2+ / MIT
-- 
2.17.1

