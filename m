Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F52E590D6D
	for <lists+io-uring@lfdr.de>; Fri, 12 Aug 2022 10:34:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229464AbiHLIey (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 12 Aug 2022 04:34:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230049AbiHLIex (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 12 Aug 2022 04:34:53 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F025A721B
        for <io-uring@vger.kernel.org>; Fri, 12 Aug 2022 01:34:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-Id:Date:Cc:To:From;
        bh=9n8eFO8XMUfghIJ1UEWQVRQaYTqey4Wvlh7X/fJjFXA=; b=QFXcio1AjQE7xKfMa8TaUpV1H1
        mkpNRJtzM8YcUIsBQNky3f3gSs6U5ZvQYc7jjudDsKoIA4VVZHQPCAEpnUMYeodvQju4OoWq3oPO4
        c/NCy+cogt1K2CMQ6pxXAJQgLghdEQuol41Z16q/BydvxA1+TJUfz7qGESaJ5blJwaqKtFfptht+O
        nT7+ZMHH8zplbfgt2iMHJbzz/TfdC9/+y8vtVZWl1iAylitaf9RjXe4Sm+Yk3t96o4/YmggpFYzfW
        wMP56AdM5fkfzN9fhYf4bOnJhiJQbQxAU8W4ksTg1exOgz3mujiLvioa/6rpMHPESWziTju9RpHR3
        55e1v4fuLxOqNTuPNPZB2vzMytyt7F5S98Ds0475IG/Qp16Ka2jDAR2jXI5bdAnyj/UqWJriR7D8i
        EUkpW/nmI2x8N/jOksVq8d3HqWcB0gclZBhAH2L5uZLmNziWZ1RZw/GkIRDt0PQDGCK37RePsyf6G
        E0wiZICara3cLoCvNOQSZ5Ot;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1oMQ82-009Jb7-3g; Fri, 12 Aug 2022 08:34:50 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     io-uring@vger.kernel.org, axboe@kernel.dk
Cc:     Stefan Metzmacher <metze@samba.org>
Subject: [RFC PATCH 1/8] io_uring: move the current struct io_uring_sqe members to legacy sub struct
Date:   Fri, 12 Aug 2022 10:34:25 +0200
Message-Id: <e9842775e56d4e5623ac04c7691f8d4887682aa5.1660291547.git.metze@samba.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1660291547.git.metze@samba.org>
References: <cover.1660291547.git.metze@samba.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Adding more and more opcodes makes the layout of struct io_uring_sqe
really complex and very hard to keep an overview what fields are
required to be the same for all opcodes and which can be adjusted
per opcode.

Adding unnamed union and struct, doesn't change anything to current
callers.

Check with 'git show -w' it's mainly just an indentation change.

The next patches will fill the union with specific structure for
each .prep() function.

Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 include/uapi/linux/io_uring.h | 129 ++++++++++++++++++----------------
 1 file changed, 67 insertions(+), 62 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 1463cfecb56b..83f16bce3dc7 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -16,72 +16,77 @@
  * IO submission data structure (Submission Queue Entry)
  */
 struct io_uring_sqe {
-	__u8	opcode;		/* type of operation for this sqe */
-	__u8	flags;		/* IOSQE_ flags */
-	__u16	ioprio;		/* ioprio for the request */
-	__s32	fd;		/* file descriptor to do IO on */
 	union {
-		__u64	off;	/* offset into file */
-		__u64	addr2;
+		/* This is the legacy structure */
 		struct {
-			__u32	cmd_op;
-			__u32	__pad1;
+			__u8	opcode;		/* type of operation for this sqe */
+			__u8	flags;		/* IOSQE_ flags */
+			__u16	ioprio;		/* ioprio for the request */
+			__s32	fd;		/* file descriptor to do IO on */
+			union {
+				__u64	off;	/* offset into file */
+				__u64	addr2;
+				struct {
+					__u32	cmd_op;
+					__u32	__pad1;
+				};
+			};
+			union {
+				__u64	addr;	/* pointer to buffer or iovecs */
+				__u64	splice_off_in;
+			};
+			__u32	len;		/* buffer size or number of iovecs */
+			union {
+				__kernel_rwf_t	rw_flags;
+				__u32		fsync_flags;
+				__u16		poll_events;	/* compatibility */
+				__u32		poll32_events;	/* word-reversed for BE */
+				__u32		sync_range_flags;
+				__u32		msg_flags;
+				__u32		timeout_flags;
+				__u32		accept_flags;
+				__u32		cancel_flags;
+				__u32		open_flags;
+				__u32		statx_flags;
+				__u32		fadvise_advice;
+				__u32		splice_flags;
+				__u32		rename_flags;
+				__u32		unlink_flags;
+				__u32		hardlink_flags;
+				__u32		xattr_flags;
+				__u32		msg_ring_flags;
+			};
+			__u64	user_data;	/* data to be passed back at completion time */
+			/* pack this to avoid bogus arm OABI complaints */
+			union {
+				/* index into fixed buffers, if used */
+				__u16	buf_index;
+				/* for grouped buffer selection */
+				__u16	buf_group;
+			} __attribute__((packed));
+			/* personality to use, if used */
+			__u16	personality;
+			union {
+				__s32	splice_fd_in;
+				__u32	file_index;
+				struct {
+					__u16	notification_idx;
+					__u16	addr_len;
+				};
+			};
+			union {
+				struct {
+					__u64	addr3;
+					__u64	__pad2[1];
+				};
+				/*
+				 * If the ring is initialized with IORING_SETUP_SQE128, then
+				 * this field is used for 80 bytes of arbitrary command data
+				 */
+				__u8	cmd[0];
+			};
 		};
 	};
-	union {
-		__u64	addr;	/* pointer to buffer or iovecs */
-		__u64	splice_off_in;
-	};
-	__u32	len;		/* buffer size or number of iovecs */
-	union {
-		__kernel_rwf_t	rw_flags;
-		__u32		fsync_flags;
-		__u16		poll_events;	/* compatibility */
-		__u32		poll32_events;	/* word-reversed for BE */
-		__u32		sync_range_flags;
-		__u32		msg_flags;
-		__u32		timeout_flags;
-		__u32		accept_flags;
-		__u32		cancel_flags;
-		__u32		open_flags;
-		__u32		statx_flags;
-		__u32		fadvise_advice;
-		__u32		splice_flags;
-		__u32		rename_flags;
-		__u32		unlink_flags;
-		__u32		hardlink_flags;
-		__u32		xattr_flags;
-		__u32		msg_ring_flags;
-	};
-	__u64	user_data;	/* data to be passed back at completion time */
-	/* pack this to avoid bogus arm OABI complaints */
-	union {
-		/* index into fixed buffers, if used */
-		__u16	buf_index;
-		/* for grouped buffer selection */
-		__u16	buf_group;
-	} __attribute__((packed));
-	/* personality to use, if used */
-	__u16	personality;
-	union {
-		__s32	splice_fd_in;
-		__u32	file_index;
-		struct {
-			__u16	notification_idx;
-			__u16	addr_len;
-		};
-	};
-	union {
-		struct {
-			__u64	addr3;
-			__u64	__pad2[1];
-		};
-		/*
-		 * If the ring is initialized with IORING_SETUP_SQE128, then
-		 * this field is used for 80 bytes of arbitrary command data
-		 */
-		__u8	cmd[0];
-	};
 };
 
 /*
-- 
2.34.1

