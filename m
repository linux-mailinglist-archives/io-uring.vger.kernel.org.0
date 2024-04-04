Return-Path: <io-uring+bounces-1398-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 31F85899319
	for <lists+io-uring@lfdr.de>; Fri,  5 Apr 2024 04:20:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9EB34B225C6
	for <lists+io-uring@lfdr.de>; Fri,  5 Apr 2024 02:20:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54D1C125C0;
	Fri,  5 Apr 2024 02:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T1Zds3kD"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0A47101F2;
	Fri,  5 Apr 2024 02:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712283601; cv=none; b=RbZ/IlJ+uD1DED0J/06gpkFj9ZWLsHiyou9WY5f5A+t48ff/apxL8mX6KlZaCzWD7UV6oL0yDyvbu30/s01hqUBysDT9rKlKZ2RktsjSMK7zsdlamj+wHKIV53lEArmbz2qp9l3SH0FbXtmT640svmQMYynpkAoey/DH7ZIBO2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712283601; c=relaxed/simple;
	bh=2DYTKFCxaDTpCQ12eT+9jVBI7+leHm0ooeFmGLJgzTE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pGU6XwOm+8KNf1p3lKBwriT78e2TYBlOmeZZ5eklH+3J827uO9Wgo4j8vk5flnC+8aDBtddkjNIbS8ctWI7ApfVtHBv2BWLWNuYtek26Gy0GdGOzbD+d1jgcPDe4mZuH3s5gO5glv4IKNm2XLRKYDcJUBNGVKULdcfwpG8u5Qkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=T1Zds3kD; arc=none smtp.client-ip=209.85.219.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-6963c0c507eso18855456d6.1;
        Thu, 04 Apr 2024 19:19:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712283598; x=1712888398; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cizTluUusU/8LespqdwSJr+fCAo0OEMHrmoen45RruY=;
        b=T1Zds3kDow7K5FbKBAv0aPSgTMl8PXKGPdnlkSH0jxqcM8OgiQyTnzAk0BwjjTmirO
         gu2SIY6+TlDsgMRmqRWnxjEPHFfsJj6nZ0GfJNIC2+US9P0vvJ0s5mskVvUKa0yDPWkp
         +LtDgo4nZyTr69LoPUA3Mt2j2mBE0meZXsMzwTewMGDSuZKiLJzglF814+Mf0uZ9UnMC
         Ky8SGaB5BUe8UobcYy2IMQl1OHbmaofZasbjQRPzbltA5dIQQ5BDvD00AEY9qvPddqcQ
         oxPbZSy/tsDLXvml/pvDkBVHV7OUVRv11RQ50DbO18AQ2es+qNr/dJoWsgD3OYc5OKF0
         ziWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712283598; x=1712888398;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cizTluUusU/8LespqdwSJr+fCAo0OEMHrmoen45RruY=;
        b=R6c/7XauUD78X/Iq0U36RXwpuEQaDPbpdW1mGylfFXemT2yR/VHPP2HGSfikFExLcg
         oiV1Dx3FS/x7QxN/FMyhvm7GKO3kJirZGTrY1Sg0tjQ5sChN8Q03fZSFdgqZ0ELdrYzD
         S8fYxeq1y/BBJ74es+BgF1WmSTQCMWafIlR8ZnMle5aW7LBV5RkKXkuAKPoF9GjZfFCb
         ku7CLEWg0msP9V4X4Rg1+MPvtSK5nE7YqQixNDO1hYo1fiXnzbo+nav5ZSaFH6KzDbOM
         +6q1fUkklIb6I5sUmFMJgUZ/FO9owXvWxdPjJzTt7Wf95kr08kH5mp/+InEzgzflXoVw
         Elpg==
X-Forwarded-Encrypted: i=1; AJvYcCUdE4GU2EXjEnTlO+BV8ecezAvEMm7Ivl/jpdGQ3SUG4VudcBKStvyXWYCziCqwb2lhj/WVp7xRkKUrjJHJFBvMDKGSlOGXIRLU9E1+BGL5FLMkFgz72ZlqxujSaF02mx4R9rcI6yMsVq8jJd5cx/Gb3gdMdCBSFCgQ3ks381rdg2y6hZ5B
X-Gm-Message-State: AOJu0Yx3ZW77wN6ObPx4pXTRSNw8mhNUJlKH8BPPtx8FX5/6Pin+6cL1
	VyXYlwu8EWM5AF6HOcgep6buhuTUR3o8CkqAaFbuUd7I2QaLnvyL
X-Google-Smtp-Source: AGHT+IGHqrNkxNFn83ZsabNt/OGQdpSNkJMryp83nT7fa8Roho4klsxduoA+FlIxnJaOonFD9Lskow==
X-Received: by 2002:a0c:fa8e:0:b0:696:8e65:b6a4 with SMTP id o14-20020a0cfa8e000000b006968e65b6a4mr2037023qvn.31.1712283598544;
        Thu, 04 Apr 2024 19:19:58 -0700 (PDT)
Received: from localhost ([2601:8c:502:14f0:acdd:1182:de4a:7f88])
        by smtp.gmail.com with ESMTPSA id ek1-20020ad45981000000b00699032e555bsm250035qvb.127.2024.04.04.19.19.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Apr 2024 19:19:58 -0700 (PDT)
Date: Thu, 4 Apr 2024 18:19:59 -0400
From: Oliver Crumrine <ozlinuxc@gmail.com>
To: axboe@kernel.dk, asml.silence@gmail.com, davem@davemloft.net, 
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, shuah@kernel.org, 
	leitao@debian.org
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] io_uring: Support IOSQE_CQE_SKIP_SUCCESS in io_uring
 zerocopy test
Message-ID: <d6d94eafa59055eaec8e554c3078f857c832a38e.1712268605.git.ozlinuxc@gmail.com>
References: <cover.1712268605.git.ozlinuxc@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1712268605.git.ozlinuxc@gmail.com>

Add support for the IOSQE_CQE_SKIP_SUCCESS flag in the io_uring_zerocopy_tx
test, using the "-a" option. Instead of incrementing when
IORING_CQE_F_MORE is set, remember how many SQEs are sent and simply
wait on notifs instead of regular completions. For non-zc stuff, there
won't be notifs or completions, so don't wait on either of those, but
check the completion queue for errors at the end to make sure none have
popped up.

The changes to the shell script run the tests both with and without the
"-a" option.

Signed-off-by: Oliver Crumrine <ozlinuxc@gmail.com>
---
 .../selftests/net/io_uring_zerocopy_tx.c      | 38 +++++++++++++++++--
 .../selftests/net/io_uring_zerocopy_tx.sh     |  7 +++-
 2 files changed, 39 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/net/io_uring_zerocopy_tx.c b/tools/testing/selftests/net/io_uring_zerocopy_tx.c
index 76e604e4810e..11a43594935f 100644
--- a/tools/testing/selftests/net/io_uring_zerocopy_tx.c
+++ b/tools/testing/selftests/net/io_uring_zerocopy_tx.c
@@ -50,8 +50,10 @@ enum {
 };
 
 static bool cfg_cork		= false;
+static bool cfg_nocqe		= false;
 static int  cfg_mode		= MODE_ZC_FIXED;
 static int  cfg_nr_reqs		= 8;
+static int  cfg_nr_completions	= 8;
 static int  cfg_family		= PF_UNSPEC;
 static int  cfg_payload_len;
 static int  cfg_port		= 8000;
@@ -134,11 +136,21 @@ static void do_tx(int domain, int type, int protocol)
 			if (mode == MODE_NONZC) {
 				io_uring_prep_send(sqe, fd, payload,
 						   cfg_payload_len, msg_flags);
+				if (cfg_nocqe) {
+					sqe->flags |= IOSQE_CQE_SKIP_SUCCESS;
+					cfg_nr_completions--;
+				}
 				sqe->user_data = NONZC_TAG;
 			} else {
 				io_uring_prep_sendzc(sqe, fd, payload,
 						     cfg_payload_len,
 						     msg_flags, zc_flags);
+				if (cfg_nocqe) {
+					sqe->flags |= IOSQE_CQE_SKIP_SUCCESS;
+					packets++;
+					compl_cqes++;
+					bytes += cfg_payload_len;
+				}
 				if (mode == MODE_ZC_FIXED) {
 					sqe->ioprio |= IORING_RECVSEND_FIXED_BUF;
 					sqe->buf_index = buf_idx;
@@ -153,7 +165,7 @@ static void do_tx(int domain, int type, int protocol)
 
 		if (cfg_cork)
 			do_setsockopt(fd, IPPROTO_UDP, UDP_CORK, 0);
-		for (i = 0; i < cfg_nr_reqs; i++) {
+		for (i = 0; i < cfg_nr_completions; i++) {
 			ret = io_uring_wait_cqe(&ring, &cqe);
 			if (ret)
 				error(1, ret, "wait cqe");
@@ -168,7 +180,9 @@ static void do_tx(int domain, int type, int protocol)
 				if (compl_cqes <= 0)
 					error(1, -EINVAL, "notification mismatch");
 				compl_cqes--;
-				i--;
+				if (!cfg_nocqe)
+					i--;
 				io_uring_cqe_seen(&ring);
 				continue;
 			}
@@ -200,6 +214,17 @@ static void do_tx(int domain, int type, int protocol)
 		compl_cqes--;
 	}
 
+	/* The above code does not account for a send error when
+	 * IOSQE_CQE_SKIP_SUCCESS is set. This is operating under the
+	 * assumption that an error CQE will get put on the ring before
+	 * the above code completes:
+	 */
+	while (!io_uring_peek_cqe(&ring, &cqe)) {
+		if (cqe->res == -EAGAIN)
+			continue;
+		error(1, -EINVAL, "send failed");
+	}
+
 	fprintf(stderr, "tx=%lu (MB=%lu), tx/s=%lu (MB/s=%lu)\n",
 			packets, bytes >> 20,
 			packets / (cfg_runtime_ms / 1000),
@@ -221,7 +246,7 @@ static void do_test(int domain, int type, int protocol)
 static void usage(const char *filepath)
 {
 	error(1, 0, "Usage: %s (-4|-6) (udp|tcp) -D<dst_ip> [-s<payload size>] "
-		    "[-t<time s>] [-n<batch>] [-p<port>] [-m<mode>]", filepath);
+		    "[-t<time s>] [-n<batch>] [-p<port>] [-m<mode>] [-a]", filepath);
 }
 
 static void parse_opts(int argc, char **argv)
@@ -239,7 +264,7 @@ static void parse_opts(int argc, char **argv)
 		usage(argv[0]);
 	cfg_payload_len = max_payload_len;
 
-	while ((c = getopt(argc, argv, "46D:p:s:t:n:c:m:")) != -1) {
+	while ((c = getopt(argc, argv, "46aD:p:s:t:n:c:m:")) != -1) {
 		switch (c) {
 		case '4':
 			if (cfg_family != PF_UNSPEC)
@@ -274,6 +299,9 @@ static void parse_opts(int argc, char **argv)
 		case 'm':
 			cfg_mode = strtol(optarg, NULL, 0);
 			break;
+		case 'a':
+			cfg_nocqe = true;
+			break;
 		}
 	}
 
@@ -302,6 +330,8 @@ static void parse_opts(int argc, char **argv)
 		error(1, 0, "-s: payload exceeds max (%d)", max_payload_len);
 	if (optind != argc - 1)
 		usage(argv[0]);
+
+	cfg_nr_completions = cfg_nr_reqs;
 }
 
 int main(int argc, char **argv)
diff --git a/tools/testing/selftests/net/io_uring_zerocopy_tx.sh b/tools/testing/selftests/net/io_uring_zerocopy_tx.sh
index 123439545013..aeb4645b7891 100755
--- a/tools/testing/selftests/net/io_uring_zerocopy_tx.sh
+++ b/tools/testing/selftests/net/io_uring_zerocopy_tx.sh
@@ -25,11 +25,14 @@ readonly path_sysctl_mem="net.core.optmem_max"
 # No arguments: automated test
 if [[ "$#" -eq "0" ]]; then
 	IPs=( "4" "6" )
+	SKIPCQEs=("" "-a")
 
 	for IP in "${IPs[@]}"; do
 		for mode in $(seq 1 3); do
-			$0 "$IP" udp -m "$mode" -t 1 -n 32
-			$0 "$IP" tcp -m "$mode" -t 1 -n 1
+			for cqe in "${SKIPCQEs[@]}"; do
+				$0 "$IP" udp -m "$mode" -t 1 -n 32 "$cqe"
+				$0 "$IP" tcp -m "$mode" -t 1 -n 1  "$cqe"
+			done
 		done
 	done
 
-- 
2.44.0


