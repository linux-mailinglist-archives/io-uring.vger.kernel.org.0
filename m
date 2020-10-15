Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3213A28F674
	for <lists+io-uring@lfdr.de>; Thu, 15 Oct 2020 18:11:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388461AbgJOQLH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Oct 2020 12:11:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388357AbgJOQLH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Oct 2020 12:11:07 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C50AC061755
        for <io-uring@vger.kernel.org>; Thu, 15 Oct 2020 09:11:05 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id w17so4822370ilg.8
        for <io-uring@vger.kernel.org>; Thu, 15 Oct 2020 09:11:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=1S5KDbQ1p20CuPkNhd9MKTHki1OPIcARm5C3GR0zXlE=;
        b=Zq8zrijKaBjlJIqXOZzNPwiOQ9G/7La1BsbjF7IqpZPkWKIe97wo9qAFp03jKt1P28
         sqwc04YE5+eoJuV5xmUpB/yPvXd1kSg5kDcSELxUO7ilZEUxdUqTeCYER3QHOZwiLLGh
         0WmxMcpxX3li3eg/SqayPvfCkMYRaiKFEOX7/ru/28Lg5ChVQoTZ8UXPz/KCUZ4xutzu
         +AQ04Xl9llpQeLxOP6ewOBAjyQDt8FnAsMXCKLs/wNwETneWCwYzHAmXFRBWXG6YCNQJ
         D/8eXoAd5OwNXTE4FFqPLAA0g6hzJs2cOgDgvRql2b9HL4d/VvMmBxiRVuRHgak8OlSW
         d68g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1S5KDbQ1p20CuPkNhd9MKTHki1OPIcARm5C3GR0zXlE=;
        b=jaymnD9kHGxkOAXhzK/dnFJ1IF7o+4g0dz+RWIFrAEFHdvJ+uVjx7SWX68uJ0GDWo8
         TW9lzebvkOU+I7RLMPf2vLUrEsa4kaR8OEvdHE+F9Nd+U0dAtanuGpGuWm29q36Y6kQb
         fXY4drucBHLPYQmybrH/S9BBnYPi7NwnhlLIOgqvOLEZva1P1I1dlmQM368WNPCIrT9G
         MJMwDZNQnbWt7KIYwlpStgVVun2crJ1/eJPuslnskoS8B42V6aG3GTfgFwwJ2/QdZu6+
         aoKjZJ7z4kphGwT4XWNeghteCiK7TBvaDXx/mbmWK1t5eMA1ULoq9fx4B6Yi5p4t4/Tj
         /UyQ==
X-Gm-Message-State: AOAM532Jzdg1xTqqvLQPMC52TOevZON0S86VgFCGIPZhYZeKHlRiZNFj
        pXJKq708fGCZ3fs6lFTLK3U9R34Ye6/P+A==
X-Google-Smtp-Source: ABdhPJywT1dPbYXSPNPCysISCZWsIoG0QWgcMNxp4OrxB4SlOsRK3TVM3NJj4VFya2zY21eKYe6CgA==
X-Received: by 2002:a92:ca92:: with SMTP id t18mr3771565ilo.287.1602778264469;
        Thu, 15 Oct 2020 09:11:04 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id d6sm2880757iln.26.2020.10.15.09.11.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Oct 2020 09:11:03 -0700 (PDT)
Subject: Re: Samba with multichannel and io_uring
To:     Stefan Metzmacher <metze@samba.org>,
        Samba Technical <samba-technical@lists.samba.org>,
        io-uring <io-uring@vger.kernel.org>
References: <53d63041-5931-c5f2-2f31-50b5cbe09ec8@samba.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <efb8b619-ca06-5c6b-e052-0c40b64b9904@kernel.dk>
Date:   Thu, 15 Oct 2020 10:11:02 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <53d63041-5931-c5f2-2f31-50b5cbe09ec8@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/15/20 3:58 AM, Stefan Metzmacher wrote:
> Hi,
> 
> related to my talk at the virtual storage developer conference
> "multichannel / iouring Status Update within Samba"
> (https://www.samba.org/~metze/presentations/2020/SDC/),
> I have some additional updates.
> 
> DDN was so kind to sponsor about a week of research on real world
> hardware with 100GBit/s interfaces and two NUMA nodes per server.
> 
> I was able to improve the performance drastically.
> 
> I concentrated on SMB2 read performance, but similar improvements would be expected for write too.
> 
> We used "server multi channel support = yes" and the network interface is RSS capable,
> it means that a Windows client uses 4 connections by default.
> 
> I first tested a share using /dev/shm and the results where really slow,
> it was not possible to reach more than ~30 GBits/s on the net and ~ 3.8 GBytes/s
> from fio.exe.
> 
> smbd uses pread() from within a pthread based threadpool for file io
> and sendmsg() to deliver the response to the socket. All multichannel
> connections are served by the same smbd process (based on the client guid).
> 
> The main smbd is cpu bound and the helper threads also use quite some cpu
> about ~ 600% in total!
> 
> https://www.samba.org/~metze/presentations/2020/SDC/future/read-32GBit-4M-2T-shm-sendmsg-top-02.png
> 
> It turns out that NUMA access caused a lot of slow down.
> The network adapter was connected to numa node 1, so we pinned
> the ramdisk and smbd to that node.
> 
>   mount -t tmpfs -o size=60g,mpol=bind:1 tmpfs /dev/shm-numanode1
>   numactl --cpunodebind=netdev:ens3f0 --membind=netdev:ens3f0 smbd
> 
> With that it was possible to reach ~ 5 GBytes/s from fio.exe
> 
> But the main problem remains the kernel is busy copying data
> and sendmsg() takes up to 0.5 msecs, which means that we don't process new requests
> during these 0.5 msecs.
> 
> I created a prototype that uses IORING_OP_SENDMSG with IOSQE_ASYNC (I used a 5.8.12 kernel)
> instead of the sync sendmsg() calls, which means that one kernel thread
> (io_wqe_work ~50% cpu) per connection is doing the memory copy to the socket
> and the main smbd only uses ~11% cpu, but we still use > 400% cpu in total.
> 
> https://www.samba.org/~metze/presentations/2020/SDC/future/read-57GBit-4M-2T-shm-io-uring-sendmsg-async-top-02.png
> 
> But it seems the numa binding for the io_wqe_work thread doesn't seem to work as expected,
> so the results vary between 5.0 GBytes/s and 7.6 GBytes/s, depending on which numa node
> io_wqe_work kernel threads are running. Also note that the threadpool with pread was
> still faster than using IORING_OP_READV towards the filesystem, the reason might also
> be numa dependent.
> 
> https://www.samba.org/~metze/presentations/2020/SDC/future/read-57GBit-4M-2T-shm-io-uring-sendmsg-async-numatop-02.png
> https://www.samba.org/~metze/presentations/2020/SDC/future/read-57GBit-4M-2T-shm-io-uring-sendmsg-async-perf-top-02.png
> 
> The main problem is still copy_user_enhanced_fast_string, so I tried to use
> IORING_IO_SPLICE (from the filesystem via a pipe to the socket) in order to avoid
> copying memory around.
> 
> With that I was able to reduce the cpu usage of the main smbd to ~6% cpu with
> io_wqe_work threads using between ~3-6% cpu (filesystem to pipe) and
> 6-30% cpu (pipe to socket).
> 
> But the Windows client wasn't able to reach better numbers than 7.6 GBytes/s (65 GBits/s).
> Only using "Set-SmbClientConfiguration -ConnectionCountPerRssNetworkInterface 16" helped to
> get up to 8.9 GBytes/s (76 GBits/s).
> 
> With 8 MByte IOs smbd is quite idle at ~ 5% cpu with the io_wqe_work threads ~100% cpu in total.
> https://www.samba.org/~metze/presentations/2020/SDC/future/read-75GBit-8M-20T-RSS16-shm-io-uring-splice-top-02.png
> 
> With 512 KByte IOs smbd uses ~56% cpu with the io_wqe_work threads ~130% cpu in total.
> https://www.samba.org/~metze/presentations/2020/SDC/future/read-76GBit-512k-10T-RSS16-shm-io-uring-splice-02.png
> 
> With 256 KByte IOS smbd uses ~87% cpu with the io_wqe_work threads ~180% cpu in total.
> https://www.samba.org/~metze/presentations/2020/SDC/future/read-76GBit-256k-10T-RSS16-shm-io-uring-splice-02.png
> 
> In order to get higher numbers I also tested with smbclient.
> 
> - With the default configuration (sendmsg and threadpool pread) I was able to get
>   4.2 GBytes/s over a single connection, while smbd with all threads uses ~150% cpu.
>   https://www.samba.org/~metze/presentations/2020/SDC/future/read-4.2G-smbclient-shm-sendmsg-pthread.png
> 
> - With IORING_IO_SPLICE I was able to get 5 GBytes/s over a single connection,
>   while smbd uses ~ 6% cpu, with 2 io_wqe_work threads (filesystem to pipe) at 5.3% cpu each +
>   1 io_wqe_work thread (pipe to socket) at ~29% cpu. This is only ~55% cpu in total on the server
>   and the client is the bottleneck here.
>   https://www.samba.org/~metze/presentations/2020/SDC/future/read-5G-smbclient-shm-io-uring-sendmsg-splice-async.png
> 
> - With a modified smbclient using a forced client guid I used 4 connections into
>   a single smbd on the server. With that I was able to reach ~ 11 GBytes/s (92 GBits/s)
>   (This is similar to what 4 iperf instances are able to reach).
>   The main smbd uses 8.6 % cpu with 4 io_wqe_work threads (pipe to socket) at ~20% cpu each.
>   https://www.samba.org/~metze/presentations/2020/SDC/future/read-11G-smbclient-same-client-guid-shm-io-uring-splice-async.png
> 
> - With 8 smbclient instances over loopback we are able to reach ~ 22 GBytes/s (180 GBits/s)
>   and smbd uses 22 % cpu.
>   https://www.samba.org/~metze/presentations/2020/SDC/future/read-22G-smbclient-8-same-client-guid-localhost-shm-io-uring-splice.png
> 
> So IORING_IO_SPLICE will bring us into a very good shape for streaming reads.
> Also note that numa pinning is not really needed here as the memory is not really touched at all.
> 
> It's very likely that IORING_IO_RECVMSG in combination with IORING_IO_SPLICE would also improve the write path.
> 
> Using AF_KCM socket (Kernel Connection Multiplexor) as wrapper to the
> (TCP) stream socket might be able to avoid wakeups for incoming packets and
> should allow better buffer management for incoming packets within smbd.
> 
> The prototype/work in process patches are available here:
> https://git.samba.org/?p=metze/samba/wip.git;a=shortlog;h=refs/heads/v4-13-multichannel
> and
> https://git.samba.org/?p=metze/samba/wip.git;a=shortlog;h=refs/heads/master-multichannel
> 
> Also notice the missing generic multichannel things via this meta bug:
> https://bugzilla.samba.org/show_bug.cgi?id=14534
> 
> I'm not sure when all this will be production ready, but it's great to know
> the potential we have on a modern Linux kernel!
> 
> Later SMB-Direct should be able to reduce the cpu load of the io_wqe_work threads (pipe to socket)...

Thanks for sending this, very interesting! As per this email, I took a
look at the NUMA bindings. If you can, please try this one-liner below.
I'd be interested to know if that removes the fluctuations you're seeing
due to bad locality.

Looks like kthread_create_on_node() doesn't actually do anything (at
least in terms of binding).


diff --git a/fs/io-wq.c b/fs/io-wq.c
index 74b84e8562fb..7bebb198b3df 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -676,6 +676,7 @@ static bool create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index)
 		kfree(worker);
 		return false;
 	}
+	kthread_bind_mask(worker->task, cpumask_of_node(wqe->node));
 
 	raw_spin_lock_irq(&wqe->lock);
 	hlist_nulls_add_head_rcu(&worker->nulls_node, &wqe->free_list);

-- 
Jens Axboe

