Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E75FC2E1F3D
	for <lists+io-uring@lfdr.de>; Wed, 23 Dec 2020 17:06:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727641AbgLWQFE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Dec 2020 11:05:04 -0500
Received: from bedivere.hansenpartnership.com ([96.44.175.130]:34262 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727360AbgLWQFE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Dec 2020 11:05:04 -0500
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id D32A412809AE;
        Wed, 23 Dec 2020 08:04:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1608739463;
        bh=dzRbIAIFFOVOpKnDTOA6zj0KHef4324sFMv5xTBqMv8=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=UOJqbOiPCHjby5AESe5JFFEouYk+7tGM0MdXl1UUaO5WknQH6hP4It7J3GKxcEi95
         Yte0Ppq4ypfucjFU3ZXlhSB3CzxVj/rcDo+FxKT5WH0PyxzP08G4QrDqX877Em71j9
         QH2hzjXQGwyh49OWRTJ42Aqg9mNa9g8Tkf2ap8ls=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id c3cuwwSOf488; Wed, 23 Dec 2020 08:04:23 -0800 (PST)
Received: from jarvis.int.hansenpartnership.com (c-73-35-198-56.hsd1.wa.comcast.net [73.35.198.56])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id D1B9C12809AD;
        Wed, 23 Dec 2020 08:04:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1608739463;
        bh=dzRbIAIFFOVOpKnDTOA6zj0KHef4324sFMv5xTBqMv8=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=UOJqbOiPCHjby5AESe5JFFEouYk+7tGM0MdXl1UUaO5WknQH6hP4It7J3GKxcEi95
         Yte0Ppq4ypfucjFU3ZXlhSB3CzxVj/rcDo+FxKT5WH0PyxzP08G4QrDqX877Em71j9
         QH2hzjXQGwyh49OWRTJ42Aqg9mNa9g8Tkf2ap8ls=
Message-ID: <f06ece44a86eb9c8ef07bbd9f6f53342366b7751.camel@HansenPartnership.com>
Subject: Re: [PATCH v1 0/6] no-copy bvec
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Christoph Hellwig <hch@infradead.org>,
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
Date:   Wed, 23 Dec 2020 08:04:22 -0800
In-Reply-To: <20201223155145.GA5902@infradead.org>
References: <cover.1607976425.git.asml.silence@gmail.com>
         <20201215014114.GA1777020@T590>
         <103235c1-e7d0-0b55-65d0-013d1a09304e@gmail.com>
         <20201215120357.GA1798021@T590>
         <e755fec3-4181-1414-0603-02e1a1f4e9eb@gmail.com>
         <20201222141112.GE13079@infradead.org>
         <933030f0-e428-18fd-4668-68db4f14b976@gmail.com>
         <20201223155145.GA5902@infradead.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, 2020-12-23 at 15:51 +0000, Christoph Hellwig wrote:
> On Wed, Dec 23, 2020 at 12:52:59PM +0000, Pavel Begunkov wrote:
> > Can scatterlist have 0-len entries? Those are directly translated
> > into bvecs, e.g. in nvme/target/io-cmd-file.c and
> > target/target_core_file.c. I've audited most of others by this
> > moment, they're fine.
> 
> For block layer SGLs we should never see them, and for nvme neither.
> I think the same is true for the SCSI target code, but please double
> check.

Right, no-one ever wants to see a 0-len scatter list entry.  The reason
is that every driver uses the sgl to program the device DMA engine in
the way NVME does.  a 0 length sgl would be a dangerous corner case:
some DMA engines would ignore it and others would go haywire, so if we
ever let a 0 length list down into the driver, they'd have to
understand the corner case behaviour of their DMA engine and filter it
accordingly, which is why we disallow them in the upper levels, since
they're effective nops anyway.

James


