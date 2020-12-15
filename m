Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FCA82DA5B8
	for <lists+io-uring@lfdr.de>; Tue, 15 Dec 2020 02:44:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730759AbgLOBnQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Dec 2020 20:43:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43150 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729950AbgLOBnH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Dec 2020 20:43:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607996496;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PChAzdtbpi+PB7J87DcIhi+vl5NjETLfLM7SecPuwcY=;
        b=D4nl2gL4la6+D2+IqWeSUygjBs0qRcl9nktwhpcKZuoLUcg+o1VcfHmjPFlcsTERBcJPc+
        SbHNSXL+fG1ZXnVFSEFM1+kf8ar0jwNhIn02WSmpsc7PLcD4k83jclGwPazOWQEul2V37L
        vfige2R1arLMU8nHd3DPIuIAK9R//UY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-335-VMEMQTasPqiCfO3btqz3Kw-1; Mon, 14 Dec 2020 20:41:34 -0500
X-MC-Unique: VMEMQTasPqiCfO3btqz3Kw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A3829180A086;
        Tue, 15 Dec 2020 01:41:31 +0000 (UTC)
Received: from T590 (ovpn-13-7.pek2.redhat.com [10.72.13.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 29ED213470;
        Tue, 15 Dec 2020 01:41:18 +0000 (UTC)
Date:   Tue, 15 Dec 2020 09:41:14 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, target-devel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH v1 0/6] no-copy bvec
Message-ID: <20201215014114.GA1777020@T590>
References: <cover.1607976425.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1607976425.git.asml.silence@gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Dec 15, 2020 at 12:20:19AM +0000, Pavel Begunkov wrote:
> Instead of creating a full copy of iter->bvec into bio in direct I/O,
> the patchset makes use of the one provided. It changes semantics and
> obliges users of asynchronous kiocb to track bvec lifetime, and [1/6]
> converts the only place that doesn't.

Just think of one corner case: iov_iter(BVEC) may pass bvec table with zero
length bvec, which may not be supported by block layer or driver, so
this patchset has to address this case first.

Please see 7e24969022cb ("block: allow for_each_bvec to support zero len bvec").


thanks,
Ming

