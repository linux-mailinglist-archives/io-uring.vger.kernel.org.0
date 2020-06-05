Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9C091F00A1
	for <lists+io-uring@lfdr.de>; Fri,  5 Jun 2020 21:56:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727960AbgFET4V (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 5 Jun 2020 15:56:21 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:42525 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727863AbgFET4U (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 5 Jun 2020 15:56:20 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 523065C0109;
        Fri,  5 Jun 2020 15:56:19 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Fri, 05 Jun 2020 15:56:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anarazel.de; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=D6vt9gBiLyKHt92f/HQgjkgJ2Q2
        oq0bpnd7yn/4J0h8=; b=kWWIUCwtE9BkYrCPSjXeOWMJSRqR3W/DQR2NT73JWNd
        95JwqJTPLTPaJhOpm9wHSqNHSUKxmj8RTMQoe78WndHYh2OJ19bY44w0q/nehS4m
        +ws/PgGocqQ8hqN/j26aJFlJmEzNpRG2b7SoArwMcpG/imn6Ml/2CT4ssyBSAPue
        zVf74EOvOurcmkIgomPAED4vekHJ7HGmNfhpYuv+TolGLXGA7P2sSqXA40v74OB6
        6r7+NNGwZEh6wSRYDKMoXWPBM1g4ZOL17ZB/uxUAFXx3ZMRK7yrdYjyz4qKVZxo9
        UKPvbyGvb1tNIdn3AOxVseec+Rh/DjZgXXW/8AIW7lw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=D6vt9g
        BiLyKHt92f/HQgjkgJ2Q2oq0bpnd7yn/4J0h8=; b=d42KY1RgOEYjooO2BSnUcn
        4Ml9DCHcWFUyEo2+zsli2YP2AaYiCjVbklcHhx/PrIW1J4tGbGgRz7674b5EVLeR
        KMxKdDHOnbtJw3LB0vpxFeQoEhMsRVQHlg5VsMJVPpeQY5DM34QIJsFy31DoXIxx
        tcDmcBT8z4U0XhzBTXDI5pWCvy9x3b2i2HvK8oA+3tBuHSbJTfv1wkHyGcNkf2dJ
        rkD/kHeQHMZfw5Q+R0CKrG9UZa4jgFYGwxJUQzDwZmHLMwZ7hMxxlyJ72uWX9rSm
        Vuu0vPHTJ1NlP+OCcKVRl+tAsruvVYdZ6b7lK+0TTkgPU+iAKkHXAVwKAP19ol/g
        ==
X-ME-Sender: <xms:YqPaXk0yXnUeoH7U0bntwQDl-soBjrCHjTGcPZlekRH99VrAEIg6qw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudegfedguddvlecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomheptehnughr
    vghsucfhrhgvuhhnugcuoegrnhgurhgvshesrghnrghrrgiivghlrdguvgeqnecuggftrf
    grthhtvghrnhepveffjefhuefgveeivdfffedugfejieetveehtdefleeiteetiedviedu
    lefggfegnecuffhomhgrihhnpehgihhthhhusgdrtghomhenucfkphepieejrdduiedtrd
    dvudejrddvhedtnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhf
    rhhomheprghnughrvghssegrnhgrrhgriigvlhdruggv
X-ME-Proxy: <xmx:YqPaXvG0PgcF4L_IVcsVkNqIgr3H5L5hVjc--RNYLgi6AiKPYCHCPQ>
    <xmx:YqPaXs7ozy8aM-kigyp0fyNXkFMV_NqJfKKk06GdiuDP-bjOw9kBcQ>
    <xmx:YqPaXt2feq1faw70bIagxXW_IV0LxEtV-riFssXbf0wmFK7_WbACcQ>
    <xmx:Y6PaXsQNhhivg6HgBYUeffWH59fSESlMpSl7t4IgROXsYskpPsT2Ww>
Received: from intern.anarazel.de (c-67-160-217-250.hsd1.ca.comcast.net [67.160.217.250])
        by mail.messagingengine.com (Postfix) with ESMTPA id A45D33280059;
        Fri,  5 Jun 2020 15:56:18 -0400 (EDT)
Date:   Fri, 5 Jun 2020 12:56:17 -0700
From:   Andres Freund <andres@anarazel.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org
Subject: Re: [PATCHSET v5 0/12] Add support for async buffered reads
Message-ID: <20200605195617.26wwsvoo4cvnmdum@alap3.anarazel.de>
References: <20200526195123.29053-1-axboe@kernel.dk>
 <20200604005916.niy2mejjcsx4sv6t@alap3.anarazel.de>
 <e3072371-1d6b-8ae5-d946-d83e60427cb0@kernel.dk>
 <20200604013045.7gu7xopreusbdea2@alap3.anarazel.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200604013045.7gu7xopreusbdea2@alap3.anarazel.de>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

On 2020-06-03 18:30:45 -0700, Andres Freund wrote:
> > I'll try and reproduce this, any chance you have a test case that can
> > be run so I don't have to write one from scratch? The more detailed
> > instructions the better.
>
> It shouldn't be too hard to write you a detailed script for reproducing
> the issue. But it'd not be an all that minimal reproducer, unless it
> also triggers on smaller scale (it's a 130GB database that triggers the
> problem reliably, and small tables don't seem to do so reliably).
>
> I'll try to write that up after I set up kvm / repro there.

Sorry, took a bit longer. Ran into some issues with my aio branch when
running on 5.6. Not yet sure if that's my fault, or io_uring's.


Here's a recipe that repros reliably for me. For me it triggers reliably
at this size (-s 1000 ends up around ~16GB).


# Build aio branch of postgres
sudo mkdir /srv/src
sudo chown andres. /srv/src
cd /srv/src
git clone -b aio https://github.com/anarazel/postgres.git pg
cd pg
./configure --enable-depend --with-liburing --prefix=/home/andres/bin/
make -j48 -s install

# check that target directory is in PATH
type psql
psql is /home/andres/bin/bin/psql

in one shell:
# create database directory, start postgres
echo 1200 | sudo tee /proc/sys/vm/nr_hugepages
initdb /srv/pguringcrash
postgres -D /srv/pguringcrash/ -c bgwriter_delay=10ms -c bgwriter_lru_maxpages=1000 -c wal_level=minimal -c max_wal_senders=0 -c wal_buffers=128MB -c max_wal_size=100GB -c shared_buffers=2GB -c max_parallel_workers_per_gather=8 -c huge_pages=on

in the other shell:
# fill with test data (skipping index creation etc)
pgbench -i -s 1000 postgres -IdtGv -q

# and trigger a parallel sequential scan, using 8 additional workers
echo 3 | sudo tee /proc/sys/vm/drop_caches && psql -c 'SET max_parallel_workers_per_gather=8' -c 'SELECT SUM(abalance) FROM pgbench_accounts ;'


For me that faily reliably triggers the issue within a few seconds.

[  323.312854] BUG: unable to handle page fault for address: 00007f0f1428c000
[  323.319879] #PF: supervisor read access in kernel mode
[  323.321391] #PF: error_code(0x0001) - permissions violation
[  323.323019] PGD 102e760067 P4D 102e760067 PUD 1037878067 PMD 8000000fc7e000e7
[  323.325065] Oops: 0001 [#1] SMP NOPTI
[  323.326248] CPU: 1 PID: 3145 Comm: postgres Not tainted 5.7.0-rc7-andres-00133-gc8707bf69395 #43
[  323.328653] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.13.0-1 04/01/2014
[  323.330365] RIP: 0010:__wake_up_common+0x53/0x140
[  323.331276] Code: 41 f6 01 04 0f 85 a3 00 00 00 48 8b 43 08 48 8d 78 e8 48 8d 43 08 48 89 c1 48 89 04 24 48 8d 47 18 48 39 c1 0f 84 b8 00 00 00 <48> 8b 47 18 89 54 24 14 31 ed 4c 8d 60 e8 8b 1f f6 c3 04 75 52 48
[  323.334419] RSP: 0018:ffffc90000dcbdc8 EFLAGS: 00010086
[  323.335409] RAX: 00007f0f1428c000 RBX: ffff889038b189f8 RCX: ffff889038b18a00
[  323.336723] RDX: 0000000000000001 RSI: 0000000000000003 RDI: 00007f0f1428bfe8
[  323.338035] RBP: 0000000000000246 R08: 0000000000000001 R09: ffffc90000dcbe18
[  323.339331] R10: ffff889036a5e750 R11: 0000000000000000 R12: 0000000000000001
[  323.340312] R13: 0000000000000003 R14: 0000000000000000 R15: 0000000000000001
[  323.341204] FS:  00007f0f6f271740(0000) GS:ffff88903f840000(0000) knlGS:0000000000000000
[  323.342217] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  323.342950] CR2: 00007f0f1428c000 CR3: 0000001037ed0005 CR4: 0000000000760ee0
[  323.343836] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  323.344724] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  323.345613] PKRU: 55555554
[  323.346017] Call Trace:
[  323.346435]  __wake_up_common_lock+0x7c/0xc0
[  323.347015]  ep_free+0x30/0xd0
[  323.347468]  ep_eventpoll_release+0x16/0x20
[  323.348040]  __fput+0xda/0x240
[  323.348498]  task_work_run+0x62/0x90
[  323.349015]  exit_to_usermode_loop+0xbd/0xe0
[  323.349573]  do_syscall_64+0xf2/0x130
[  323.349987]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  323.350523] RIP: 0033:0x7f0f6f5a5f13
[  323.350906] Code: 00 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb bb 0f 1f 80 00 00 00 00 64 8b 04 25 18 00 00 00 85 c0 75 14 b8 03 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 45 c3 0f 1f 40 00 48 83 ec 18 89 7c 24 0c e8
[  323.352501] RSP: 002b:00007ffdf3eab5a8 EFLAGS: 00000246 ORIG_RAX: 0000000000000003
[  323.353277] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00007f0f6f5a5f13
[  323.353947] RDX: 0000000000000001 RSI: 000055ef9f5cb360 RDI: 000000000000002a
[  323.354587] RBP: 000055ef9f5cb2e8 R08: 00000000000280e8 R09: 0000000000000143
[  323.355227] R10: 000000000000000a R11: 0000000000000246 R12: 000055ef9f5cb2e8
[  323.355872] R13: 0000000000000008 R14: 00000000ffffffff R15: 00007f0f6d3407a4
[  323.356510] Modules linked in: 9pnet_virtio isst_if_common iTCO_wdt 9pnet xhci_pci iTCO_vendor_support xhci_hcd
[  323.357477] CR2: 00007f0f1428c000
[  323.357866] ---[ end trace 081898b3c6b5ab1b ]---


I'll try your new branch next.

Greetings,

Andres Freund
