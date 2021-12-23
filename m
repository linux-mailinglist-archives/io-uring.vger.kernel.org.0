Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F39147E176
	for <lists+io-uring@lfdr.de>; Thu, 23 Dec 2021 11:31:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243167AbhLWKbB convert rfc822-to-8bit (ORCPT
        <rfc822;lists+io-uring@lfdr.de>); Thu, 23 Dec 2021 05:31:01 -0500
Received: from mailgate.zerties.org ([144.76.28.47]:57416 "EHLO
        mailgate.zerties.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243143AbhLWKbA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Dec 2021 05:31:00 -0500
X-Greylist: delayed 1477 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 Dec 2021 05:31:00 EST
Received: from ip5f5ab8c1.dynamic.kabel-deutschland.de ([95.90.184.193] helo=localhost)
        by mailgate.zerties.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <stettberger@dokucode.de>)
        id 1n0KzK-000ZjF-On; Thu, 23 Dec 2021 10:06:21 +0000
From:   Christian Dietrich <stettberger@dokucode.de>
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>,
        horst.schirmeier@tu-dresden.de,
        "Franz-B. Tuneke" <franz-bernhard.tuneke@tu-dortmund.de>,
        Hendrik Sieck <hendrik.sieck@tuhh.de>
In-Reply-To: <20211214055734.61702-1-haoxu@linux.alibaba.com>
Organization: Technische =?utf-8?Q?Universit=C3=A4t?= Hamburg
References: <20211214055734.61702-1-haoxu@linux.alibaba.com>
X-Commit-Hash-org: f01fca33b1535359a4f3d7fe903261c35a059bba
X-Commit-Hash-Maildir: 21463e538b8be37cea4aa13f1c503800360e4a44
Date:   Thu, 23 Dec 2021 11:06:17 +0100
Message-ID: <s7by24bd49y.fsf@dokucode.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-SA-Do-Not-Rej: Yes
X-SA-Exim-Connect-IP: 95.90.184.193
X-SA-Exim-Mail-From: stettberger@dokucode.de
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on mailgate.zerties.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=4.0 tests=ALL_TRUSTED,BAYES_00,
        URIBL_BLOCKED shortcircuit=no autolearn=ham autolearn_force=no
        version=3.4.4
Subject: Re: [POC RFC 0/3] support graph like dependent sqes
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi everyone!

We experimented with the BPF patchset provided by Pavel a few months
ago. And I had the exact same question: How can we compare the benefits
and drawbacks of a more flexible io_uring implementation? In that
specific use case, I wanted to show that a flexible SQE-dependency
generation with BPF could outperform user-space SQE scheduling. From my
experience with BPF, I learned that it is quite hard to beat
io_uring+userspace, if there is enough parallelism in your IO jobs.

For this purpose, I've built a benchmark generator that is able to
produce random dependency graphs of various shapes (isolated nodes,
binary tree, parallel-dependency chains, random DAC) and different
scheduling backends (usual system-call backend, plain io_uring,
BPF-enhanced io_uring) and different workloads.

At this point, I didn't have the time to polish the generator and
publish it, but I put the current state into this git:

https://collaborating.tuhh.de/e-exk4/projects/syscall-graph-generator

After running:

    ./generate.sh
    [sudo modprobe null_blk...]
    ./run.sh
    ./analyze.py

You get the following results (at least if you own my machine):

generator              iouring      syscall      iouring_norm
graph action size
chain read   128    938.563366  2019.199010   46.48%
flat  read   128    922.132673  2011.566337   45.84%
graph read   128   1129.017822  2021.905941   55.84%
rope  read   128   2051.763366  2014.563366  101.85%
tree  read   128   1049.427723  2015.254455   52.07%

For the userspace scheduler, I perform an offline analysis that finds
linear chains of operations that are not (anymore) dependent on other previous
unfinished results. These linear chains are then pushed into io_uring
with a SQE-link chain.

As I'm highly interested in this topic of pushing complex
IO-dependencies into the kernel space, I would be delighted to see how
your SQE-graph extension would compare against my rudimentary userspace
scheduler.

@Hao: Do you have a specific use case for your graph-like dependencies
      in mind? If you need assistance with the generator, please feel
      free to contact me.

chris
-- 
Prof. Dr.-Ing. Christian Dietrich
Operating System Group (E-EXK4)
Technische Universität Hamburg
Am Schwarzenberg-Campus 3 (E), 4.092
21073 Hamburg

eMail:  christian.dietrich@tuhh.de
Tel:    +49 40 42878 2188
WWW:    https://osg.tuhh.de/
