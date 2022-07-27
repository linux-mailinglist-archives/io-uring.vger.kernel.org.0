Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E49205829B5
	for <lists+io-uring@lfdr.de>; Wed, 27 Jul 2022 17:34:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233650AbiG0Pe2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 27 Jul 2022 11:34:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233215AbiG0Pe1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 27 Jul 2022 11:34:27 -0400
Received: from euporie.uberspace.de (euporie.uberspace.de [185.26.156.232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50CB22CE04
        for <io-uring@vger.kernel.org>; Wed, 27 Jul 2022 08:34:26 -0700 (PDT)
Received: (qmail 15140 invoked by uid 989); 27 Jul 2022 15:27:44 -0000
Authentication-Results: euporie.uberspace.de;
        auth=pass (plain)
From:   Florian Fischer <florian.fischer@muhq.space>
To:     io-uring@vger.kernel.org
Cc:     Florian Schmaus <flow@cs.fau.de>,
        Florian Fischer <florian.fischer@muhq.space>
Subject: [PATCH liburing 4/9] meson: update installed manpages to liburing 2.3
Date:   Wed, 27 Jul 2022 17:27:18 +0200
Message-Id: <20220727152723.3320169-5-florian.fischer@muhq.space>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727152723.3320169-1-florian.fischer@muhq.space>
References: <20220727152723.3320169-1-florian.fischer@muhq.space>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Bar: --
X-Rspamd-Report: BAYES_SPAM(0.001119) R_MISSING_CHARSET(0.5) MIME_GOOD(-0.1) REPLY(-4) MID_CONTAINS_FROM(1)
X-Rspamd-Score: -2.59888
Received: from unknown (HELO unkown) (::1)
        by euporie.uberspace.de (Haraka/2.8.28) with ESMTPSA; Wed, 27 Jul 2022 17:27:44 +0200
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,
        MSGID_FROM_MTA_HEADER,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Signed-off-by: Florian Fischer <florian.fischer@muhq.space>
---
 man/meson.build | 123 +++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 116 insertions(+), 7 deletions(-)

diff --git a/man/meson.build b/man/meson.build
index 94e44b3..8f4ec7e 100644
--- a/man/meson.build
+++ b/man/meson.build
@@ -1,7 +1,116 @@
-install_man('io_uring.7',
-            'io_uring_enter.2',
-            'io_uring_get_sqe.3',
-            'io_uring_queue_exit.3',
-            'io_uring_queue_init.3',
-            'io_uring_register.2',
-            'io_uring_setup.2')
+install_man(
+  'io_uring.7',
+  'io_uring_buf_ring_add.3',
+  'io_uring_buf_ring_advance.3',
+  'io_uring_buf_ring_cq_advance.3',
+  'io_uring_buf_ring_init.3',
+  'io_uring_buf_ring_mask.3',
+  'io_uring_cq_advance.3',
+  'io_uring_cqe_get_data.3',
+  'io_uring_cqe_get_data64.3',
+  'io_uring_cqe_seen.3',
+  'io_uring_cq_ready.3',
+  'io_uring_enter.2',
+  'io_uring_free_probe.3',
+  'io_uring_get_probe.3',
+  'io_uring_get_sqe.3',
+  'io_uring_opcode_supported.3',
+  'io_uring_peek_cqe.3',
+  'io_uring_prep_accept.3',
+  'io_uring_prep_accept_direct.3',
+  'io_uring_prep_cancel.3',
+  'io_uring_prep_close.3',
+  'io_uring_prep_close_direct.3',
+  'io_uring_prep_connect.3',
+  'io_uring_prep_fadvise.3',
+  'io_uring_prep_fallocate.3',
+  'io_uring_prep_files_update.3',
+  'io_uring_prep_fsync.3',
+  'io_uring_prep_link.3',
+  'io_uring_prep_linkat.3',
+  'io_uring_prep_madvise.3',
+  'io_uring_prep_mkdir.3',
+  'io_uring_prep_mkdirat.3',
+  'io_uring_prep_msg_ring.3',
+  'io_uring_prep_multishot_accept.3',
+  'io_uring_prep_multishot_accept_direct.3',
+  'io_uring_prep_openat2.3',
+  'io_uring_prep_openat2_direct.3',
+  'io_uring_prep_openat.3',
+  'io_uring_prep_openat_direct.3',
+  'io_uring_prep_poll_add.3',
+  'io_uring_prep_poll_multishot.3',
+  'io_uring_prep_poll_remove.3',
+  'io_uring_prep_poll_update.3',
+  'io_uring_prep_provide_buffers.3',
+  'io_uring_prep_read.3',
+  'io_uring_prep_read_fixed.3',
+  'io_uring_prep_readv2.3',
+  'io_uring_prep_readv.3',
+  'io_uring_prep_recv.3',
+  'io_uring_prep_recv_multishot.3',
+  'io_uring_prep_recvmsg.3',
+  'io_uring_prep_recvmsg_multishot.3',
+  'io_uring_prep_remove_buffers.3',
+  'io_uring_prep_rename.3',
+  'io_uring_prep_renameat.3',
+  'io_uring_prep_send.3',
+  'io_uring_prep_sendmsg.3',
+  'io_uring_prep_shutdown.3',
+  'io_uring_prep_socket.3',
+  'io_uring_prep_socket_direct.3',
+  'io_uring_prep_splice.3',
+  'io_uring_prep_statx.3',
+  'io_uring_prep_symlink.3',
+  'io_uring_prep_symlinkat.3',
+  'io_uring_prep_sync_file_range.3',
+  'io_uring_prep_tee.3',
+  'io_uring_prep_timeout.3',
+  'io_uring_prep_timeout_remove.3',
+  'io_uring_prep_timeout_update.3',
+  'io_uring_prep_unlink.3',
+  'io_uring_prep_unlinkat.3',
+  'io_uring_prep_write.3',
+  'io_uring_prep_write_fixed.3',
+  'io_uring_prep_writev2.3',
+  'io_uring_prep_writev.3',
+  'io_uring_queue_exit.3',
+  'io_uring_queue_init.3',
+  'io_uring_queue_init_params.3',
+  'io_uring_recvmsg_cmsg_firsthdr.3',
+  'io_uring_recvmsg_cmsg_nexthdr.3',
+  'io_uring_recvmsg_name.3',
+  'io_uring_recvmsg_out.3',
+  'io_uring_recvmsg_payload.3',
+  'io_uring_recvmsg_payload_length.3',
+  'io_uring_recvmsg_validate.3',
+  'io_uring_register.2',
+  'io_uring_register_buffers.3',
+  'io_uring_register_buf_ring.3',
+  'io_uring_register_eventfd.3',
+  'io_uring_register_eventfd_async.3',
+  'io_uring_register_files.3',
+  'io_uring_register_iowq_aff.3',
+  'io_uring_register_iowq_max_workers.3',
+  'io_uring_register_ring_fd.3',
+  'io_uring_setup.2',
+  'io_uring_sqe_set_data.3',
+  'io_uring_sqe_set_data64.3',
+  'io_uring_sqe_set_flags.3',
+  'io_uring_sq_ready.3',
+  'io_uring_sqring_wait.3',
+  'io_uring_sq_space_left.3',
+  'io_uring_submit.3',
+  'io_uring_submit_and_wait.3',
+  'io_uring_submit_and_wait_timeout.3',
+  'io_uring_unregister_buffers.3',
+  'io_uring_unregister_buf_ring.3',
+  'io_uring_unregister_eventfd.3',
+  'io_uring_unregister_files.3',
+  'io_uring_unregister_iowq_aff.3',
+  'io_uring_unregister_ring_fd.3',
+  'io_uring_wait_cqe.3',
+  'io_uring_wait_cqe_nr.3',
+  'io_uring_wait_cqes.3',
+  'io_uring_wait_cqe_timeout.3',
+)
-- 
2.37.1

