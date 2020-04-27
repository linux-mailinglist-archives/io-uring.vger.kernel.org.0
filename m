Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D8471BAEE5
	for <lists+io-uring@lfdr.de>; Mon, 27 Apr 2020 22:10:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726811AbgD0UKp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Apr 2020 16:10:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726442AbgD0UKo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Apr 2020 16:10:44 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80E08C0610D5;
        Mon, 27 Apr 2020 13:10:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=6pD6p9aux5pF6FGW8nXxgJwlIf6ft9bSmHybrTl2pyE=; b=qk+yNGJQ5uDzUXXVzPR6QHPxyL
        kee0kwt1BnMU3Ir5irHRMhQMZmPpygVzeD0Dkf3cCk0RD0UO2s+voqtRDjpWzQgtMNQZ2xHttQTn3
        eVurZdlMYr4KGn3WwulYVRyqV/M79WSUuYJR2vCW5M8CliXz5UAUVecAzdGfE3AYPlHt7RFtw8V7q
        EOgAQEbbEvC2fvtOJbPllzgSoAOGB+y/P2Pr4C0tTJEkuqwUTQqutI2ZokZlVffZ9a7f+445PjLLW
        pd6AfECpRmYJKgy0E5Zkuk8ZBPt59lvdfUbrgjhYVRnfQZP7/3H+B4A31ZHHhbzYE0mgKTr1SuIS7
        VQCAMAOg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jTA5T-00052J-3e; Mon, 27 Apr 2020 20:10:43 +0000
Date:   Mon, 27 Apr 2020 13:10:43 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Jann Horn <jannh@google.com>,
        Andreas Smas <andreas@lonelycoder.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>
Subject: Re: io_uring, IORING_OP_RECVMSG and ancillary data
Message-ID: <20200427201043.GA6292@infradead.org>
References: <CAObFT-S27KXFGomqPZdXA8oJDe6QxmoT=T6CBgD9R9UHNmakUQ@mail.gmail.com>
 <f75d30ff-53ec-c3a1-19b2-956735d44088@kernel.dk>
 <CAG48ez32nkvLsWStjenGmZdLaSPKWEcSccPKqgPtJwme8ZxxuQ@mail.gmail.com>
 <bd37ec95-2b0b-40fc-8c86-43805e2990aa@kernel.dk>
 <45d7558a-d0c8-4d3f-c63a-33fd2fb073a5@kernel.dk>
 <CAG48ez0pHbz3qvjQ+N6r0HfAgSYdDnV1rGy3gCzcuyH6oiMhBQ@mail.gmail.com>
 <217dc782-161f-7aea-2d18-4e88526b8e1d@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <217dc782-161f-7aea-2d18-4e88526b8e1d@kernel.dk>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Apr 27, 2020 at 02:08:25PM -0600, Jens Axboe wrote:
> Possibly... Totally untested, maybe I forgot to mention that :-)
> I'll check.
> 
> The question was more "in principle" if this was a viable approach. The
> whole cmsg_type and cmsg_level is really a mess.

FYI, I have a series in the works to sort out the set_fs and
casting to/from __user mess around msg_control.  It needs a little
more work, but hopefully I can find some time the next days.
