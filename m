Return-Path: <io-uring+bounces-12916-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SIW1BJQ1zWlwawYAu9opvQ
	(envelope-from <io-uring+bounces-12916-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 01 Apr 2026 17:11:16 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 9889F37CC56
	for <lists+io-uring@lfdr.de>; Wed, 01 Apr 2026 17:11:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 31CF03009B16
	for <lists+io-uring@lfdr.de>; Wed,  1 Apr 2026 14:59:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC84635A3A0;
	Wed,  1 Apr 2026 14:59:44 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from proxmox-new.maurer-it.com (proxmox-new.maurer-it.com [94.136.29.106])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 040BB2F546D;
	Wed,  1 Apr 2026 14:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=94.136.29.106
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775055584; cv=none; b=GPTl+0w9C2hG5bbYYhezxe/XWdlJhnQkf/bKAoJOtAQU8CY8ENjY62dU4ljX39tLwQrRNqWnqgH7LMFxpFeD1fEk83oDAMclOSMN4UEWSIjO6J5JVA6qGc7mHWZWhi/bF0Fue9st2IKEV5PB/zVmKrCEHSxxrQdDTMvMlhu6xog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775055584; c=relaxed/simple;
	bh=LLgrdH5e9kkqT8/CF+vXRWLbAr+/hTEp5thB3QRwdjI=;
	h=Message-ID:Date:MIME-Version:From:Cc:Subject:To:Content-Type; b=EsfN1kbYaVno/0xZsyEktBT/U7BfQn+JnLuqqr6tLG3w0NR3FDct6LslDjJxSiinZJSeTODNToKZNfM15yJZ63x4Y2i25bdq/YRO2fGhEM/MorJ/tofpjvrJeIM0GuGbm4Ffsa3B1rvJsYq8kpgVBsWTgiF4T0mW+tvUYYaDaTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=proxmox.com; spf=pass smtp.mailfrom=proxmox.com; arc=none smtp.client-ip=94.136.29.106
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=proxmox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proxmox.com
Received: from proxmox-new.maurer-it.com (localhost.localdomain [127.0.0.1])
	by proxmox-new.maurer-it.com (Proxmox) with ESMTP id 2DBA8864A9;
	Wed, 01 Apr 2026 16:59:34 +0200 (CEST)
Message-ID: <14bc6266-5bc9-4454-9518-d1016bfe417b@proxmox.com>
Date: Wed, 1 Apr 2026 16:59:33 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
From: Fiona Ebner <f.ebner@proxmox.com>
Cc: hannes@cmpxchg.org, surenb@google.com, peterz@infradead.org,
 io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: io_uring_prep_timeout() leading to an IO pressure close to 100
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Bm-Milter-Handled: 55990f41-d878-4baa-be0a-ee34c49e34d2
X-Bm-Transport-Timestamp: 1775055516354
X-Spamd-Result: default: False [-1.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns];
	RCVD_COUNT_THREE(0.00)[4];
	TAGGED_RCPT(0.00)[io-uring];
	NEURAL_HAM(-0.00)[-0.959];
	MID_RHS_MATCH_FROM(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	R_DKIM_NA(0.00)[];
	DMARC_NA(0.00)[proxmox.com];
	RCVD_TLS_LAST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[f.ebner@proxmox.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12916-lists,io-uring=lfdr.de];
	RCPT_COUNT_FIVE(0.00)[6]
X-Rspamd-Queue-Id: 9889F37CC56
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Dear maintainers,

I'm currently investigating an issue with QEMU causing an IO pressure
value of nearly 100 when io_uring is used for the event loop of a QEMU
iothread (which is the case since QEMU 10.2 if io_uring is enabled
during configuration and available).

The cause seems to be the io_uring_prep_timeout() call that is used for
blocking wait. I attached a minimal reproducer below, which exposes the
issue [0].

This was observed on a kernel based on 7.0-rc6 as well as 6.17.13. I
haven't investigated what happens inside the kernel yet, so I don't know
if it is an accounting issue or within io_uring.

Let me know if you need more information or if I should test something
specific.

Best Regards,
Fiona

[0]:

#include <errno.h>
#include <stdio.h>
#include <liburing.h>

int main(void) {
    int ret;
    struct io_uring ring;
    struct __kernel_timespec ts;
    struct io_uring_sqe *sqe;

    ret = io_uring_queue_init(128, &ring, 0);
    if (ret != 0) {
        printf("Failed to initialize io_uring\n");
        return ret;
    }

    ts = (struct __kernel_timespec){
        .tv_sec = 60,
    };

    sqe = io_uring_get_sqe(&ring);
    if (!sqe) {
        printf("Full sq\n");
        return -1;
    }

    io_uring_prep_timeout(sqe, &ts, 1, 0);
    io_uring_sqe_set_data(sqe, NULL);

    do {
        ret = io_uring_submit_and_wait(&ring, 1);
        printf("got ret %d\n", ret);
    } while (ret == -EINTR);

    io_uring_queue_exit(&ring);

    return 0;
}



