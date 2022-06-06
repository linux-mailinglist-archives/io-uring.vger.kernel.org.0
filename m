Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C22FE53EF98
	for <lists+io-uring@lfdr.de>; Mon,  6 Jun 2022 22:31:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233477AbiFFUbe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 6 Jun 2022 16:31:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbiFFUbR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 6 Jun 2022 16:31:17 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C694A338BC;
        Mon,  6 Jun 2022 13:30:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=L93rXd/L1ZidPKDjVR2Htth4no20aj9zrvUjNNfoLMY=; b=dhhWLCoG8TH8iYy++CZI1qdqPY
        Jh/j3TqnSVmtJn2DVh+2DlPqb3JT8asoategJN/IBTNEjZRAEityK1x/gWPo2TIHm0E4XRYHOFjao
        Rg4Gx7SXcPWXRdE3WIiN8TiRsApwlFcijLB2MdM96Iboi7LCVBohRc5eDNHhMfJ0IkXPLkqiHmktt
        lByx5JnD6OH8h/GS2gHMIYRRfboVuDjFeqlmV31a4RiV1qDy0+7n1gG3bt5H9Zok7gRfWIYxN2n/p
        k1/sOm/YIhapms25BIBt5Kjk5THdVhdZDEQ+rXKLlO6JANzcXuH4ddjX39nV4hqZmJpFLI/Sd62yz
        PwHph18w==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nyJMj-00B0Ku-8w; Mon, 06 Jun 2022 20:30:21 +0000
Date:   Mon, 6 Jun 2022 21:30:21 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz, hch@infradead.org,
        axboe@kernel.dk
Subject: Re: [PATCH v7 06/15] iomap: Return error code from iomap_write_iter()
Message-ID: <Yp5j3Yr7gnT/zbEv@casper.infradead.org>
References: <20220601210141.3773402-1-shr@fb.com>
 <20220601210141.3773402-7-shr@fb.com>
 <YpivQhqhZxwvdDUm@casper.infradead.org>
 <0f83316c-3aa2-3cb6-ede1-c2dd2dd3ab31@fb.com>
 <Yp5S9pRPKHbAgcsU@casper.infradead.org>
 <4c15cc6f-97a6-ab53-6b1c-871058608419@fb.com>
 <Yp5Uw65VFcTaSyfi@casper.infradead.org>
 <8a7c76d2-3cb4-0162-584a-69b130831c3e@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8a7c76d2-3cb4-0162-584a-69b130831c3e@fb.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Jun 06, 2022 at 12:28:04PM -0700, Stefan Roesch wrote:
> On 6/6/22 12:25 PM, Matthew Wilcox wrote:
> > On Mon, Jun 06, 2022 at 12:21:28PM -0700, Stefan Roesch wrote:
> >> On 6/6/22 12:18 PM, Matthew Wilcox wrote:
> >>> On Mon, Jun 06, 2022 at 09:39:03AM -0700, Stefan Roesch wrote:
> >>>> On 6/2/22 5:38 AM, Matthew Wilcox wrote:
> >>>>> On Wed, Jun 01, 2022 at 02:01:32PM -0700, Stefan Roesch wrote:
> >>>>>> Change the signature of iomap_write_iter() to return an error code. In
> >>>>>> case we cannot allocate a page in iomap_write_begin(), we will not retry
> >>>>>> the memory alloction in iomap_write_begin().
> >>>>>
> >>>>> loff_t can already represent an error code.  And it's already used like
> >>>>> that.
> >>>>>
> >>>>>> @@ -829,7 +830,8 @@ static loff_t iomap_write_iter(struct iomap_iter *iter, struct iov_iter *i)
> >>>>>>  		length -= status;
> >>>>>>  	} while (iov_iter_count(i) && length);
> >>>>>>  
> >>>>>> -	return written ? written : status;
> >>>>>> +	*processed = written ? written : error;
> >>>>>> +	return error;
> >>>>>
> >>>>> I think the change you really want is:
> >>>>>
> >>>>> 	if (status == -EAGAIN)
> >>>>> 		return -EAGAIN;
> >>>>> 	if (written)
> >>>>> 		return written;
> >>>>> 	return status;
> >>>>>
> >>>>
> >>>> I think the change needs to be:
> >>>>
> >>>> -    return written ? written : status;
> >>>> +    if (status == -EAGAIN) {
> >>>> +        iov_iter_revert(i, written);
> >>>> +        return -EAGAIN;
> >>>> +    }
> >>>> +    if (written)
> >>>> +        return written;
> >>>> +    return status;
> >>>
> >>> Ah yes, I think you're right.
> >>>
> >>> Does it work to leave everything the way it is, call back into the
> >>> iomap_write_iter() after having done a short write, get the -EAGAIN at
> >>> that point and pass the already-advanced iterator to the worker thread?
> >>> I haven't looked into the details of how that works, so maybe you just
> >>> can't do that.
> >>
> >> With the above change, short writes are handled correctly.
> > 
> > Are they though?  What about a write that crosses an extent boundary?
> > iomap_write_iter() gets called once per extent and I have a feeling that
> > you really need to revert the entire write, rather than just the part
> > of the write that was to that extent.
> > 
> > Anyway, my question was whether we need to revert or whether the worker
> > thread can continue from where we left off.
> 
> Without iov_iter_revert() fsx fails with errors in short writes and also my test
> program which issues short writes fails.

Does your test program include starting in one extent, completing the
portion of the write which is in that extent successfully, and having
the portion of the write which is in the second extent be short?
