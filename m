Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AFBC4F22CA
	for <lists+io-uring@lfdr.de>; Tue,  5 Apr 2022 07:58:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229861AbiDEGAm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 5 Apr 2022 02:00:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230017AbiDEGAj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 5 Apr 2022 02:00:39 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 414551658C
        for <io-uring@vger.kernel.org>; Mon,  4 Apr 2022 22:58:39 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 1231868AFE; Tue,  5 Apr 2022 07:58:36 +0200 (CEST)
Date:   Tue, 5 Apr 2022 07:58:35 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Kanchan Joshi <joshi.k@samsung.com>, axboe@kernel.dk,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        ming.lei@redhat.com, mcgrof@kernel.org, pankydev8@gmail.com,
        javier@javigon.com, joshiiitr@gmail.com, anuj20.g@samsung.com
Subject: Re: [RFC 3/5] io_uring: add infra and support for
 IORING_OP_URING_CMD
Message-ID: <20220405055835.GC23698@lst.de>
References: <20220401110310.611869-1-joshi.k@samsung.com> <CGME20220401110834epcas5p4d1e5e8d1beb1a6205d670bbcb932bf77@epcas5p4.samsung.com> <20220401110310.611869-4-joshi.k@samsung.com> <20220404071656.GC444@lst.de> <e039827d-ab7b-1791-d06c-a52ebc949de8@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e039827d-ab7b-1791-d06c-a52ebc949de8@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Apr 04, 2022 at 09:20:00AM +0100, Pavel Begunkov wrote:
>> I'm still not a fund of the double indirect call here.  I don't really
>> have a good idea yet, but I plan to look into it.
>
> I haven't familiarised myself with the series properly, but if it's about
> driver_cb, we can expose struct io_kiocb and io_req_task_work_add() so
> the lower layers can implement their own io_task_work.func. Hopefully, it
> won't be inventively abused...

If we move io_kiocb out avoiding one indirection would be very easy
indeed.  But I think that just invites abuse.  Note that we also have
at least one and potentially more indirections in this path.  The
request rq_end_io handler is a guranteed one, and the IPI or softirq
for the request indirectin is another one.  So my plan was to look
into having an io_uring specific hook in the core block code to
deliver completions directly to the right I/O uring thread.  In the
best case that should allow us to do a single indirect call for
the completion instead of 4 and a pointless IPI/softirq.

>>> +	struct io_kiocb *req = container_of(ioucmd, struct io_kiocb, uring_cmd);
>>> +
>>> +	if (ret < 0)
>>> +		req_set_fail(req);
>>> +	io_req_complete(req, ret);
>>> +}
>>> +EXPORT_SYMBOL_GPL(io_uring_cmd_done);
>>
>> It seems like all callers of io_req_complete actually call req_set_fail
>> on failure.  So maybe it would be nice pre-cleanup to handle the
>> req_set_fail call from ĩo_req_complete?
>
> Interpretation of the result is different, e.g. io_tee(), that was the
> reason it was left in the callers.

Yes, there is about two of them that would then need to be open coded
using __io_req_complete.

>
> [...]
>>> @@ -60,7 +62,10 @@ struct io_uring_sqe {
>>>   		__s32	splice_fd_in;
>>>   		__u32	file_index;
>>>   	};
>>> -	__u64	__pad2[2];
>>> +	union {
>>> +		__u64	__pad2[2];
>>> +		__u64	cmd;
>>> +	};
>>
>> Can someone explain these changes to me a little more?
>
> not required indeed, just
>
> -	__u64	__pad2[2];
> +	__u64	cmd;
> +	__u64	__pad2;

Do we still want a union for cmd and document it to say what
opcode it is for?
