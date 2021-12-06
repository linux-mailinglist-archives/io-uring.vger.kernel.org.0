Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9273646A6BE
	for <lists+io-uring@lfdr.de>; Mon,  6 Dec 2021 21:18:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240146AbhLFUVv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 6 Dec 2021 15:21:51 -0500
Received: from cloud48395.mywhc.ca ([173.209.37.211]:57816 "EHLO
        cloud48395.mywhc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349098AbhLFUVu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 6 Dec 2021 15:21:50 -0500
X-Greylist: delayed 1983 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Dec 2021 15:21:50 EST
Received: from modemcable064.203-130-66.mc.videotron.ca ([66.130.203.64]:37828 helo=[192.168.1.179])
        by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <olivier@trillion01.com>)
        id 1muKRI-00012U-U7
        for io-uring@vger.kernel.org; Mon, 06 Dec 2021 15:18:20 -0500
Message-ID: <67933da84217368a732a4820ee97b0afe47a1beb.camel@trillion01.com>
Subject: Kernel config settings known to be detrimental to io_uring
 performance?
From:   Olivier Langlois <olivier@trillion01.com>
To:     io-uring@vger.kernel.org
Date:   Mon, 06 Dec 2021 15:18:20 -0500
Organization: Trillion01 Inc
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.42.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cloud48395.mywhc.ca
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - trillion01.com
X-Get-Message-Sender-Via: cloud48395.mywhc.ca: authenticated_id: olivier@trillion01.com
X-Authenticated-Sender: cloud48395.mywhc.ca: olivier@trillion01.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

I am building a custom Kernel from ArchLinux standard Kernel package.

I do that mostly to get CONFIG_NO_HZ_FULL on since I dedicate cores to
RT threads of my app.

Beside that, I play it safe by not touching to settings that I have no
idea what they do and I keep the default upstream packaging settings.

There is one timing measurement that I do in my app. the time it takes
for:

1. Thread A to write in an eventfd to wake up thread B running an
io_uring event loop
2. thread B userspace event processing + write data in a TCP socket
through io_uring
3. thread B Receive the write CQE

With previous kernel settings, the timing that I had was 85 uSecs.

Idk why but yesterday, I felt more daring than usual I have decided
disable a couple of features that aren't needed. So I disabled:

CONFIG_AUDIT
CONFIG_SECURITY_APPARMOR (had to remove it to be allowed to remove
CONFIG_AUDIT)
CONFIG_HYPERVISOR_GUEST (my kernel will always only run on bare metal)
CONFIG_AMD_MEM_ENCRYPT (my server is Intel based)

and I have been amazed by how much faster io_uring became. My timing
went from 85 to 59.8 uSecs (A 30% improvement)!

Now, because I have disabled a couple of settings all at the same time,
I am not really sure which one is responsible for this amazing result
but I would suspect that CONFIG_AUDIT might be the one...

You know what? I would be willing to take a couple more of those juicy
30% improvements anytime...

So I was wondering if someone is aware of some other kernel config
settings that are notoriously detrimental to the kernel io_uring I/O
performance (more specifically TCP/IP)?

My next try will be to disable:
CONFIG_SECURITY_NETWORK
CONFIG_SECURITY_TOMOYO
CONFIG_SECURITY_SMACK

I suspect that I might not find another 30% improvment... but who
knows? if I do, I will report back

Greetings,

