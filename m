Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB4D53B2B4F
	for <lists+io-uring@lfdr.de>; Thu, 24 Jun 2021 11:24:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230274AbhFXJ0r (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Jun 2021 05:26:47 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:38178 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230039AbhFXJ0r (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Jun 2021 05:26:47 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id D48A421923;
        Thu, 24 Jun 2021 09:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624526667; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=il0/cwUtgiAD5jaqXCBVRaOIoH20XDAXjZdXMAfwrnc=;
        b=dd1FQ/2wfsim+6JwpUX45Tb9p//E/WE/Q0+MjqRzmuzpoAKsuu3vXUya+UtVP4Uuf6XfHb
        BvoYaA7fHO12kEWQryNc9LefuchyIsXMd2Wc35+P4DP+CCGeyMDGUrKlJJ3ow++sXsb0Wn
        gcqBctD+00RqOSydTV2iWxQjtiTbWx4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624526667;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=il0/cwUtgiAD5jaqXCBVRaOIoH20XDAXjZdXMAfwrnc=;
        b=gv37xlS3BOOpuz7rxWbWXF1RGJiwzMQCRuFsmp6f4csPSmIGr4NOIK2/sPnqjCcsjJQrS3
        ZWTM3cu9CM3U+nBQ==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id C2C7A11A97;
        Thu, 24 Jun 2021 09:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624526667; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=il0/cwUtgiAD5jaqXCBVRaOIoH20XDAXjZdXMAfwrnc=;
        b=dd1FQ/2wfsim+6JwpUX45Tb9p//E/WE/Q0+MjqRzmuzpoAKsuu3vXUya+UtVP4Uuf6XfHb
        BvoYaA7fHO12kEWQryNc9LefuchyIsXMd2Wc35+P4DP+CCGeyMDGUrKlJJ3ow++sXsb0Wn
        gcqBctD+00RqOSydTV2iWxQjtiTbWx4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624526667;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=il0/cwUtgiAD5jaqXCBVRaOIoH20XDAXjZdXMAfwrnc=;
        b=gv37xlS3BOOpuz7rxWbWXF1RGJiwzMQCRuFsmp6f4csPSmIGr4NOIK2/sPnqjCcsjJQrS3
        ZWTM3cu9CM3U+nBQ==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id TT5WL0tP1GBSQAAALh3uQQ
        (envelope-from <hare@suse.de>); Thu, 24 Jun 2021 09:24:27 +0000
Subject: Re: [LSF/MM/BPF Topic] Towards more useful nvme-passthrough
To:     Kanchan Joshi <joshi.k@samsung.com>,
        lsf-pc@lists.linux-foundation.org, linux-nvme@lists.infradead.org,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        Doug Gilbert <dgilbert@interlog.com>
Cc:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org, javier@javigon.com,
        anuj20.g@samsung.com, joshiiitr@gmail.com
References: <CGME20210609105347epcas5p42ab916655fca311157a38d54f79f95e7@epcas5p4.samsung.com>
 <20210609105050.127009-1-joshi.k@samsung.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <d9e6e3cc-fedb-eb45-7a3e-5df24e67455b@suse.de>
Date:   Thu, 24 Jun 2021 11:24:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210609105050.127009-1-joshi.k@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/9/21 12:50 PM, Kanchan Joshi wrote:
> Background & objectives:
> ------------------------
> 
> The NVMe passthrough interface
> 
> Good part: allows new device-features to be usable (at least in raw
> form) without having to build block-generic cmds, in-kernel users,
> emulations and file-generic user-interfaces - all this take some time to
> evolve.
> 
> Bad part: passthrough interface has remain tied to synchronous ioctl,
> which is a blocker for performance-centric usage scenarios. User-space
> can take the pain of implementing async-over-sync on its own but it does
> not make much sense in a world that already has io_uring.
> 
> Passthrough is lean in the sense it cuts through layers of abstractions
> and reaches to NVMe fast. One of the objective here is to build a
> scalable pass-through that can be readily used to play with new/emerging
> NVMe features.  Another is to surpass/match existing raw/direct block
> I/O performance with this new in-kernel path.
> 
> Recent developments:
> --------------------
> - NVMe now has a per-namespace char interface that remains available/usable
>   even for unsupported features and for new command-sets [1].
> 
> - Jens has proposed async-ioctl like facility 'uring_cmd' in io_uring. This
>   introduces new possibilities (beyond storage); async-passthrough is one of
> those. Last posted version is V4 [2].
> 
> - I have posted work on async nvme passthrough over block-dev [3]. Posted work
>   is in V4 (in sync with the infra of [2]).
> 
> Early performance numbers:
> --------------------------
> fio, randread, 4k bs, 1 job
> Kiops, with varying QD:
> 
> QD      Sync-PT         io_uring        Async-PT
> 1         10.8            10.6            10.6
> 2         10.9            24.5            24
> 4         10.6            45              46
> 8         10.9            90              89
> 16        11.0            169             170
> 32        10.6            308             307
> 64        10.8            503             506
> 128       10.9            592             596
> 
> Further steps/discussion points:
> --------------------------------
> 1.Async-passthrough over nvme char-dev
> It is in a shape to receive feedback, but I am not sure if community
> would like to take a look at that before settling on uring-cmd infra.
> 
> 2.Once above gets in shape, bring other perf-centric features of io_uring to
> this path -
> A. SQPoll and register-file: already functional.
> B. Passthrough polling: This can be enabled for block and looks feasible for
> char-interface as well.  Keith recently posted enabling polling for user
> pass-through [4]
> C. Pre-mapped buffers: Early thought is to let the buffers registered by
> io_uring, and add a new passthrough ioctl/uring_cmd in driver which does
> everything that passthrough does except pinning/unpinning the pages.
> 
> 3. Are there more things in the "io_uring->nvme->[block-layer]->nvme" path
> which can be optimized.
> 
> Ideally I'd like to cover good deal of ground before Dec. But there seems
> plenty of possibilities on this path.  Discussion would help in how best to
> move forward, and cement the ideas.
> 
> [1] https://lore.kernel.org/linux-nvme/20210421074504.57750-1-minwoo.im.dev@gmail.com/
> [2] https://lore.kernel.org/linux-nvme/20210317221027.366780-1-axboe@kernel.dk/
> [3] https://lore.kernel.org/linux-nvme/20210325170540.59619-1-joshi.k@samsung.com/
> [4] https://lore.kernel.org/linux-block/20210517171443.GB2709391@dhcp-10-100-145-180.wdc.com/#t
> 
I do like the idea.

What I would like to see is to make the ioring_cmd infrastructure
generally available, such that we can port the SCSI sg asynchronous
interface over to this.
Doug Gilbert has been fighting a lone battle to improve the sg
asynchronous interface, as the current one is deemed a security hazard.
But in the absence of a generic interface he had to design his own
ioctls, with all the expected pushback.
Plus there are only so many people who care about sg internals :-(

Being able to use ioring_cmd would be a neat way out of this.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
