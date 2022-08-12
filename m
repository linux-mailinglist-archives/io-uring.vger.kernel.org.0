Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD813590D6C
	for <lists+io-uring@lfdr.de>; Fri, 12 Aug 2022 10:34:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbiHLIes (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 12 Aug 2022 04:34:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbiHLIes (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 12 Aug 2022 04:34:48 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC2DF9DB55
        for <io-uring@vger.kernel.org>; Fri, 12 Aug 2022 01:34:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-Id:Date:Cc:To:From;
        bh=G1W40Kd8r0iPiYmu+fp+mmLCg8rAEDBCwJuf+rim+rw=; b=sTLuFseWt+mQdbZZEKKY2oVJ9T
        ehlrClQdaQWumY+EknMHTqMYN8+IskNHFLdoRdGFkilmIinqXhb5noaHQWM6pdm9XK4QRrWMOnqxJ
        y5wm+pcwFTf9epzNPflrol5k7zaTjzccDc5Ba5bm6Njy6a0l+140Lfyy3oXrhxqKzEaQzBpSCbB4p
        hCfxzLlY7BwAgGPA2xSuHOrGtWPcQuSY0DxS8krgcO1kmJvK2ZJwTtv8BucDqZqC2BnjRBK5RO4U+
        hnEtughw8zwK+jBwF+J+kWmfCUT6pEnh2bX4mR7rw35KtWpz55Taoi2XqsmtQAyEaRE2iaRk9iFcg
        sdBDiank43giLiGIWA3QlDI/Dd9Wu/LRJVBsu22ShVrjMFtpVdKMUiHaagAO9Ji8WQGlGuoiwLX7a
        OGOZVbZ1en1mWEFN3L5VTBE9+Df2kbO9s9fqYa/G5uORelhdErPWwviIgC3jp8LUGREfFbDglyMOG
        DK5k3jir8/E1P+kE/tzP3iTF;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1oMQ7v-009Jax-OM; Fri, 12 Aug 2022 08:34:43 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     io-uring@vger.kernel.org, axboe@kernel.dk
Cc:     Stefan Metzmacher <metze@samba.org>
Subject: [RFC PATCH 0/8] cleanup struct io_uring_sqe layout
Date:   Fri, 12 Aug 2022 10:34:24 +0200
Message-Id: <cover.1660291547.git.metze@samba.org>
X-Mailer: git-send-email 2.34.1
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

Hi Jens,

with all the nested structs, unions and scalar fields in
struct io_uring_sqe, it becomes more and more confusing to
find which fields are used by what opcode for
what and which fields are useable for new opcodes.

I started with some patches to move to a model where we have
a signle top level union with structures for each opcode
(in reality per .prep() function).

At the same time we leave the existing legacy layout as is
and enforce fields are are of the same type and at the same offset.

I only started with the first few files, but in the end
the kernel should no longer use the legacy elements.

The new stuff would look like this:

struct io_uring_sqe {
    union {

        /* This is the legacy structure */
        struct {
                __u8    opcode;         /* type of operation for this sqe */
                __u8    flags;          /* IOSQE_ flags */
                __u16   ioprio;         /* ioprio for the request */
                __s32   fd;             /* file descriptor to do IO on */
                ...
        };

        struct { /* This is the structure showing the generic fields */
                struct io_uring_sqe_hdr {
                        __u8    opcode;         /* type of operation for this sqe */
                        __u8    flags;          /* IOSQE_ flags */
                        __u16   ioprio;         /* ioprio for the request */
                        __s32   fd;             /* file descriptor to do IO on */
                } __attribute__((packed)) hdr;

                __u64   u64_ofs08;
                __u64   u64_ofs16;
                __u32   u32_ofs24;
                __u32   u32_ofs28;

                struct io_uring_sqe_common {
                        __u64   user_data;      /* data to be passed back at completion time */
                        __u16   buf_info;       /* buf_index or buf_group */
                        __u16   personality;    /* the personality to run this request under */
                } __attribute__((packed)) common;

                __u32   u32_ofs44;
                __u64   u64_ofs48;
                __u64   u64_ofs56;
        };

        /* IORING_OP_{READV,WRITEV,READ_FIXED,WRITE_FIXED,READ,WRITE} */
        struct io_uring_sqe_rw {
                struct io_uring_sqe_hdr hdr;

                __u64   offset;
                __u64   buffer_addr;
                __u32   length;
                __u32   flags;

                struct io_uring_sqe_common common;

                __u32   u32_ofs44;
                __u64   u64_ofs48;
                __u64   u64_ofs56;
        } rw;

        ...
};

At least for me it would make things much easier to understand.
Whould that be something useful?
If so we could go that way for all prep() functions and
in the end also convert liburing.

Stefan Metzmacher (8):
  io_uring: move the current struct io_uring_sqe members to legacy sub
    struct
  io_uring: add a generic structure for struct io_uring_sqe
  io_uring: check legacy layout of struct io_uring_sqe with
    BUILD_BUG_SQE_LEGACY*
  io_uring: only make use generic struct io_uring_sqe elements for
    tracing
  io_uring: only access generic struct io_uring_sqe elements in
    io_uring.c
  io_uring: add BUILD_BUG_SQE_HDR_COMMON() macro
  io_uring: introduce struct io_uring_sqe_rw for all io_prep_rw() using
    opcodes
  io_uring: introduce struct io_uring_sqe_{fsync,sfr,fallocate}

 include/trace/events/io_uring.h |  30 ++---
 include/uapi/linux/io_uring.h   | 223 +++++++++++++++++++++++---------
 io_uring/io_uring.c             | 205 ++++++++++++++++++++++-------
 io_uring/rw.c                   |  26 +++-
 io_uring/sync.c                 |  58 ++++++---
 5 files changed, 394 insertions(+), 148 deletions(-)

-- 
2.34.1

