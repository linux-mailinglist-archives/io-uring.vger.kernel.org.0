Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 245C81548BA
	for <lists+io-uring@lfdr.de>; Thu,  6 Feb 2020 17:02:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727358AbgBFQCT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 6 Feb 2020 11:02:19 -0500
Received: from hr2.samba.org ([144.76.82.148]:22496 "EHLO hr2.samba.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726925AbgBFQCT (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Thu, 6 Feb 2020 11:02:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-Id:Date:Cc:To:From;
        bh=Qkn4GFsAIuTz+Tpi0kPvJ9G0zRorBV7duO1nvciq0dQ=; b=o6Sqlgg31INXvFbpAJjQjIRBlj
        hUkOz4wql/CpfXHVbUKBdnuaYC6xntJGcralyEDyd4J+hMDCtnK4bJvcAD/yfdOSZqVWe6JE/rubk
        Az3LF3UXvLXY+nfdA1v5nTiW8Ze8kjVoSBeCGbu51s5zQkU5A2yOiK+sADsv1LutSNSvRufoSWCCa
        b3ZTI8syXuadUn0cmw6XsdKiux+gGlFaL4Jv6vLq7rV11Q6/Thwggef4ct+KRDJn6KW4YNrNOTZtG
        yTRV9SjtEBOQ2C2D+X0wUdn/h/HWJAp5xjXejWW5siPb3OSnvePGkhl5PW+z8H5J5o2sYCDxtFgPK
        ND1ODOIOqVjihC+zCtBAEXGUq1PjyI5oU+UX0mco1KNyrbsl/eGfIcunyGwV0/zhnZp2FzFrMvNoK
        ASS0ryXyRU2UK7neU83OlrDDF/ooNeqEbbIOK3emAHs+vXlRz9g/auQIv5XeCqwWTvqqfwvL48urL
        qZOU/+drzan9iHtPmltvLR6h;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1izjbd-0006Tn-2c; Thu, 06 Feb 2020 16:02:17 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     io-uring@vger.kernel.org
Cc:     Stefan Metzmacher <metze@samba.org>
Subject: [PATCH v1] io_uring_cqe_get_data() only requires a const struct io_uring_cqe *cqe
Date:   Thu,  6 Feb 2020 17:02:09 +0100
Message-Id: <20200206160209.14432-1-metze@samba.org>
X-Mailer: git-send-email 2.17.1
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 src/include/liburing.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index faed2e7..44f18fd 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -179,7 +179,7 @@ static inline void io_uring_sqe_set_data(struct io_uring_sqe *sqe, void *data)
 	sqe->user_data = (unsigned long) data;
 }
 
-static inline void *io_uring_cqe_get_data(struct io_uring_cqe *cqe)
+static inline void *io_uring_cqe_get_data(const struct io_uring_cqe *cqe)
 {
 	return (void *) (uintptr_t) cqe->user_data;
 }
-- 
2.17.1

