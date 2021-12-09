Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A39D46F4FD
	for <lists+io-uring@lfdr.de>; Thu,  9 Dec 2021 21:34:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229455AbhLIUht (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Dec 2021 15:37:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbhLIUhs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Dec 2021 15:37:48 -0500
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22C28C061746
        for <io-uring@vger.kernel.org>; Thu,  9 Dec 2021 12:34:15 -0800 (PST)
Received: by mail-il1-x12d.google.com with SMTP id t8so6509104ilu.8
        for <io-uring@vger.kernel.org>; Thu, 09 Dec 2021 12:34:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PP5JrgPQhr+QQhF25gfvGTGcXWrTxr4AXkqtONEnreE=;
        b=qpZoxSJvtlXnkEO3lJSQgFVi3hc6icFJ1YT6VT75abPZj3gfb8T5zVK/On6zXW2ztt
         /cBqtioneaAaQ74Mz5yvsbk9OFGuisdtGhuglxlpLW89koLWVa5kcQ5JWsToJUIUYfp2
         FEaKvn28fieOFvRZ7xONtdVa6a8dJdbf1TmwLoYb/xNAtgenvbeKKDeifm/goOzqHSL0
         S9t6eEW3iaC3P7+MFwVmOaDUGTGLRdE6t31bxDcZ2QSF9dTZMpT5KE/PaVYx3APUVJJN
         OGo6p1M15O5JZsu0zymJILbk7RYDtwbYm7fPMKENglHTtASS9/tvt+hQx7fWJJvoe/xg
         6+7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PP5JrgPQhr+QQhF25gfvGTGcXWrTxr4AXkqtONEnreE=;
        b=qs3Bbo8D8PmnG7qm1q2m50szMO9uCT5m2coAOlzoOm1zJkb0vVDA9QrOXinnUwk6K9
         27LrKyGGjAHlAU181gDQRE2MmqpMx0psSkeQcoL5z0+qelEOY7KkGdTT7cPKjfp4LEGt
         bBr2Jt+MORbAibhi7GhUVMj4jupCcsV+to1Qx4lvOsLJNDXLu52WLlaIeBVeIIDuVs1m
         66kdIxjvzr09BusUH2C3Iw4/gysKrqGWyx2rRHyPvhcts7fKytpk2YlAbaQnFHfCHL8b
         5LRPkFGPCTwQw5Ec+8RW1dXbTj9rqySV1LcX3AEK3Kyev9Yqz4Odmr2eHLgSPc2lTgwi
         yuCg==
X-Gm-Message-State: AOAM533bwlHLRSUwHR7dW5Ui0FmCZUDWOXnwBgwrvm8aKfh6xOAlKW+7
        00RGPoHZvGe4Hki/qtMLA6j82zFBCtQ=
X-Google-Smtp-Source: ABdhPJwSvd25JdPVA/o9Goq90fvMbAx734HmZhtX6fSyGqYhp+jbnEMpEctsrO7F0mJGZsdsC3yDmg==
X-Received: by 2002:a05:6e02:148c:: with SMTP id n12mr17511357ilk.209.1639082054571;
        Thu, 09 Dec 2021 12:34:14 -0800 (PST)
Received: from p51.localdomain (bras-base-mtrlpq4706w-grc-05-174-93-161-243.dsl.bell.ca. [174.93.161.243])
        by smtp.gmail.com with ESMTPSA id w19sm717431iov.12.2021.12.09.12.34.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 12:34:14 -0800 (PST)
Received: by p51.localdomain (Postfix, from userid 60092)
        id C5A8211C5994; Thu,  9 Dec 2021 15:34:20 -0500 (EST)
Date:   Thu, 9 Dec 2021 15:34:20 -0500
From:   jrun <darwinskernel@gmail.com>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring <io-uring@vger.kernel.org>
Subject: possible bug with unix sockets
Message-ID: <20211209203420.narvidnx5im4lja2@p51>
References: <20211208190733.xazgugkuprosux6k@p51>
 <024aae30-1fdc-f51b-7744-9518a39cbb19@gmail.com>
 <20211209175636.oq6npmqf24h5hthi@p51>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="3beanfcpnwz7bb3k"
Content-Disposition: inline
In-Reply-To: <20211209175636.oq6npmqf24h5hthi@p51>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


--3beanfcpnwz7bb3k
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Thu, Dec 09, 2021 at 12:56:36PM -0500, jrun wrote:
> also any magic with bpftrace you would suggest?

see the bt file attached, just took an example from bpftrace guys and grepped
for anything returning a socket in net/unix/af_unix.c ... suggestions are
welcome.

it seems to me that inet accepts are handled with iou-sqp whereas unix ones stay
attached to the userspace program. is that correct/expected?


	- jrun

--3beanfcpnwz7bb3k
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="tcpacceptq.bt"

#!/usr/bin/env bpftrace
/*
 * tcpaccept.bt Trace TCP accept()s
 *              For Linux, uses bpftrace and eBPF.
 *
 * USAGE: tcpaccept.bt
 *
 * This is a bpftrace version of the bcc tool of the same name.
 *
 * This uses dynamic tracing of the kernel inet_csk_accept() socket function
 * (from tcp_prot.accept), and will need to be modified to match kernel changes.

 * Copyright (c) 2018 Dale Hamel.
 * Licensed under the Apache License, Version 2.0 (the "License")

 * 23-Nov-2018	Dale Hamel	created this.
 */

#include <linux/socket.h>
#include <net/sock.h>

BEGIN
{
	printf("Tracing TCP accepts. Hit Ctrl-C to end.\n");
	printf("%-8s %-6s %-14s ", "TIME", "PID", "COMM");
	printf("%-39s %-5s %-39s %-5s %s\n", "RADDR", "RPORT", "LADDR",
	    "LPORT", "BL");
}

// static
kretprobe:unix_find_socket_byinode,
kretprobe:unix_create1,
// non-static
kretprobe:unix_peer_get,
kretprobe:inet_csk_accept
{
	$sk = (struct sock *)retval;
	$inet_family = $sk->__sk_common.skc_family;

	if ($inet_family == AF_INET || $inet_family == AF_INET6 || $inet_family == AF_UNIX) {
		// initialize variable type:
		$daddr = ntop(0);
		$saddr = ntop(0);
		if ($inet_family == AF_INET) {
			$daddr = ntop($sk->__sk_common.skc_daddr);
			$saddr = ntop($sk->__sk_common.skc_rcv_saddr);
		} else {
			$daddr = ntop(
			    $sk->__sk_common.skc_v6_daddr.in6_u.u6_addr8);
			$saddr = ntop(
			    $sk->__sk_common.skc_v6_rcv_saddr.in6_u.u6_addr8);
		}
		$lport = $sk->__sk_common.skc_num;
		$dport = $sk->__sk_common.skc_dport;
		$qlen  = $sk->sk_ack_backlog;
		$qmax  = $sk->sk_max_ack_backlog;

		// Destination port is big endian, it must be flipped
		$dport = ($dport >> 8) | (($dport << 8) & 0x00FF00);

		time("%H:%M:%S ");
		printf("%-6d %-14s ", pid, comm);
		printf("%-39s %-5d %-39s %-5d ", $daddr, $dport, $saddr,
		    $lport);
		printf("%d/%d\n", $qlen, $qmax);
	}
}

--3beanfcpnwz7bb3k--
