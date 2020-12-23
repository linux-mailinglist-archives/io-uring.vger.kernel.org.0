Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D06262E214A
	for <lists+io-uring@lfdr.de>; Wed, 23 Dec 2020 21:26:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728395AbgLWUYp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Dec 2020 15:24:45 -0500
Received: from mail-1.ca.inter.net ([208.85.220.69]:57480 "EHLO
        mail-1.ca.inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727195AbgLWUYo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Dec 2020 15:24:44 -0500
Received: from localhost (offload-3.ca.inter.net [208.85.220.70])
        by mail-1.ca.inter.net (Postfix) with ESMTP id CCEBC2EA28A;
        Wed, 23 Dec 2020 15:24:02 -0500 (EST)
Received: from mail-1.ca.inter.net ([208.85.220.69])
        by localhost (offload-3.ca.inter.net [208.85.220.70]) (amavisd-new, port 10024)
        with ESMTP id 0NtYbbCfRz7B; Wed, 23 Dec 2020 15:12:11 -0500 (EST)
Received: from [192.168.48.23] (host-104-157-204-209.dyn.295.ca [104.157.204.209])
        (using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail-1.ca.inter.net (Postfix) with ESMTPSA id 169332EA054;
        Wed, 23 Dec 2020 15:23:58 -0500 (EST)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH v1 0/6] no-copy bvec
To:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        Christoph Hellwig <hch@infradead.org>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>,
        Matthew Wilcox <willy@infradead.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, target-devel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-doc@vger.kernel.org
References: <cover.1607976425.git.asml.silence@gmail.com>
 <20201215014114.GA1777020@T590>
 <103235c1-e7d0-0b55-65d0-013d1a09304e@gmail.com>
 <20201215120357.GA1798021@T590>
 <e755fec3-4181-1414-0603-02e1a1f4e9eb@gmail.com>
 <20201222141112.GE13079@infradead.org>
 <933030f0-e428-18fd-4668-68db4f14b976@gmail.com>
 <20201223155145.GA5902@infradead.org>
 <f06ece44a86eb9c8ef07bbd9f6f53342366b7751.camel@HansenPartnership.com>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <8abc56c2-4db8-5ee3-ab2d-8960d0eeeb0d@interlog.com>
Date:   Wed, 23 Dec 2020 15:23:57 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <f06ece44a86eb9c8ef07bbd9f6f53342366b7751.camel@HansenPartnership.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2020-12-23 11:04 a.m., James Bottomley wrote:
> On Wed, 2020-12-23 at 15:51 +0000, Christoph Hellwig wrote:
>> On Wed, Dec 23, 2020 at 12:52:59PM +0000, Pavel Begunkov wrote:
>>> Can scatterlist have 0-len entries? Those are directly translated
>>> into bvecs, e.g. in nvme/target/io-cmd-file.c and
>>> target/target_core_file.c. I've audited most of others by this
>>> moment, they're fine.
>>
>> For block layer SGLs we should never see them, and for nvme neither.
>> I think the same is true for the SCSI target code, but please double
>> check.
> 
> Right, no-one ever wants to see a 0-len scatter list entry.  The reason
> is that every driver uses the sgl to program the device DMA engine in
> the way NVME does.  a 0 length sgl would be a dangerous corner case:
> some DMA engines would ignore it and others would go haywire, so if we
> ever let a 0 length list down into the driver, they'd have to
> understand the corner case behaviour of their DMA engine and filter it
> accordingly, which is why we disallow them in the upper levels, since
> they're effective nops anyway.

When using scatter gather lists at the far end (i.e. on the storage device)
the T10 examples (WRITE SCATTERED and POPULATE TOKEN in SBC-4) explicitly
allow the "number of logical blocks" in their sgl_s to be zero and state
that it is _not_ to be considered an error.

Doug Gilbert

