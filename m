Return-Path: <io-uring+bounces-3388-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AF27298E658
	for <lists+io-uring@lfdr.de>; Thu,  3 Oct 2024 00:55:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 05FE61C20A03
	for <lists+io-uring@lfdr.de>; Wed,  2 Oct 2024 22:55:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBD2219C571;
	Wed,  2 Oct 2024 22:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="QGpXtaJb"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9D6684A36
	for <io-uring@vger.kernel.org>; Wed,  2 Oct 2024 22:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727909727; cv=none; b=BT+c/3VtoUOcmw8aDNitH1fXMGaWhPefM7oYf1p+uPUt4KGQH19+O8yGByZeEHfxY795oziMsRzIphruolxxvF02c2XXHeXhuupDtsMVdKIRvy7ql97NGydIshNFIPoFcb4rlSbVD1u6XCfBN6TaG1iqHzYv2mVFjfEsLne+xpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727909727; c=relaxed/simple;
	bh=iDdjyx8b8uf+i1lPuHlzsSeXJeI9q/2tiP2XcpYN7OU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=R8+V8S7GUhoCTj9I4BwpXfOjxFkRrhAN8lRRaKxHTAxYVZ18sPnRxvOKCsM/R6DxwWFMGs9l0vaOkuoiD+/zwOrkW9QQVuuX8Pci007dqhjv1jNR3FLsTvJb+xFkGMSyvDzAzDCAzDxfK74Q2C3PEHitIayE0HMPdUFScueyJS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=QGpXtaJb; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-7db908c9c83so159078a12.2
        for <io-uring@vger.kernel.org>; Wed, 02 Oct 2024 15:55:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1727909724; x=1728514524; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/FKEqvb8gVk326XClv/YmoVUpmVfBagbVbZQZgGEjzY=;
        b=QGpXtaJbojoGmINQq/TLThpCITTTcK8J6w6dHMykdGUJ0P8rHeMAunn3aPLMNlnq9S
         Ap0qE3fzy/Fwc+m3byCyOID2VQqc7PvyksTe7SckrBYsWvVCh2m/Efp8B/3TJTjFpeOy
         nxaKttDnH+yWql83c8HMwWAnVpWQ6ISoTZ90Dmz+JpJS4Xf7YLAqyTfQdZlaKOmFPNo1
         HDHBo4jZNZvT9w2qKXP/iiZws0mVES+hMQ+UZ/5dQhHe9Uo1hvSvMhLAYQYo3wRikPaJ
         HZ6Ea7GiRNvaBWGuDMeUL/VD5yBtcW/kr/9yLxLrAY1Al82bqPehouTJal7qm9XPhBSC
         ZcDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727909724; x=1728514524;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/FKEqvb8gVk326XClv/YmoVUpmVfBagbVbZQZgGEjzY=;
        b=DN8HJFUJ0LZnZuRO/q2RHuxRp/wzZZ8KAlD90nIkH65g1NOOxBJNqWO7AFmcoJKVME
         Skof3uR8WZPnO++69gc/ZXV1dZK5a3Dl92vlILJx1MVwDWaAAXBnWKj4cO4NqcelVmMS
         4UoVuCH1rdDcIUn1dlIgZhYioTf1Wt20bMQ6BVMxSw+kRnA3HM0Mnr7AdhbGSJejJG9K
         clsM8G8xMvF1N+8U6Ym2yyMTKDcLStRv4B31UNy+cT4jt9tt72Uc5DaCsy7sJSOpxB+w
         +nBJVHT+VV1Mfw3YhXX6wgdLE1me2GM888LjH3vbO/+ArtFs6GkI/i8wW/WIeG2JdRKD
         1dzw==
X-Forwarded-Encrypted: i=1; AJvYcCVVZ/X0Txo1aBDKXpJ6PN2V1M/vCF/YKFw7oQe7rn0IobbX3b1OHioMPtrkKorJxDBHhSUz+t2I8g==@vger.kernel.org
X-Gm-Message-State: AOJu0YwQbBoWmzlGFNZ+bxs1TTAo54VMd/cZ4YASsjFi8fRhBm5qrpTE
	tOjDRS7GeXgzkCQLFypgqqxAlaolOrLFwNUW9i5BDLjvFNFOtNbrpkSPpaTUCW0=
X-Google-Smtp-Source: AGHT+IHNpL9ICLdlOrO/5G/SxKV94DA0mLNwiuH8gIKjwtE4K/+r1dEqEWnVZLYOsfDwvDQg1kzTkA==
X-Received: by 2002:a05:6a20:d499:b0:1cf:54a7:6a25 with SMTP id adf61e73a8af0-1d5e2ca7ecdmr7018699637.23.1727909723900;
        Wed, 02 Oct 2024 15:55:23 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7e6db2930a4sm10460288a12.13.2024.10.02.15.55.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Oct 2024 15:55:23 -0700 (PDT)
Message-ID: <d69b33f9-31a0-4c70-baf2-a72dc28139e0@kernel.dk>
Date: Wed, 2 Oct 2024 16:55:22 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/9] replace do_setxattr() with saner helpers.
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, brauner@kernel.org,
 io-uring@vger.kernel.org, cgzones@googlemail.com
References: <20241002011011.GB4017910@ZenIV>
 <20241002012230.4174585-1-viro@zeniv.linux.org.uk>
 <20241002012230.4174585-5-viro@zeniv.linux.org.uk>
 <12334e67-80a6-4509-9826-90d16483835e@kernel.dk>
 <20241002020857.GC4017910@ZenIV>
 <a2730d25-3998-4d76-8c12-dde7ce1be719@kernel.dk>
 <20241002211939.GE4017910@ZenIV>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20241002211939.GE4017910@ZenIV>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/2/24 3:19 PM, Al Viro wrote:
> On Wed, Oct 02, 2024 at 12:00:45PM -0600, Jens Axboe wrote:
>> On 10/1/24 8:08 PM, Al Viro wrote:
>>> On Tue, Oct 01, 2024 at 07:34:12PM -0600, Jens Axboe wrote:
>>>
>>>>> -retry:
>>>>> -	ret = filename_lookup(AT_FDCWD, ix->filename, lookup_flags, &path, NULL);
>>>>> -	if (!ret) {
>>>>> -		ret = __io_setxattr(req, issue_flags, &path);
>>>>> -		path_put(&path);
>>>>> -		if (retry_estale(ret, lookup_flags)) {
>>>>> -			lookup_flags |= LOOKUP_REVAL;
>>>>> -			goto retry;
>>>>> -		}
>>>>> -	}
>>>>> -
>>>>> +	ret = filename_setxattr(AT_FDCWD, ix->filename, LOOKUP_FOLLOW, &ix->ctx);
>>>>>  	io_xattr_finish(req, ret);
>>>>>  	return IOU_OK;
>>>>
>>>> this looks like it needs an ix->filename = NULL, as
>>>> filename_{s,g}xattr() drops the reference. The previous internal helper
>>>> did not, and hence the cleanup always did it. But should work fine if
>>>> ->filename is just zeroed.
>>>>
>>>> Otherwise looks good. I've skimmed the other patches and didn't see
>>>> anything odd, I'll take a closer look tomorrow.
>>>
>>> Hmm...  I wonder if we would be better off with file{,name}_setxattr()
>>> doing kvfree(cxt->kvalue) - it makes things easier both on the syscall
>>> and on io_uring side.
>>>
>>> I've added minimal fixes (zeroing ix->filename after filename_[sg]etxattr())
>>> to 5/9 and 6/9 *and* added a followup calling conventions change at the end
>>> of the branch.  See #work.xattr2 in the same tree; FWIW, the followup
>>> cleanup is below; note that putname(ERR_PTR(-Ewhatever)) is an explicit
>>> no-op, so there's no need to zero on getname() failures.
>>
>> Looks good to me, thanks Al!
> 
> I'm still not sure if the calling conventions change is right - in the
> current form the last commit in there leaks ctx.kvalue in -EBADF case.
> It's easy to fix up, but... as far as I'm concerned, a large part of
> the point of the exercise is to come up with the right model for the
> calling conventions for that family of APIs.

The reason I liked the putname() is that it's unconditional - the caller
can rely on it being put, regardless of the return value. So I'd say the
same should be true for ctx.kvalue, and if not, the caller should still
free it. That's the path of least surprise - no leak for the least
tested error path, and no UAF in the success case.

For the put case, most other abstractions end up being something ala:

helper(struct file *file, ...)
{
	actual actions
}

regular_sys_call(int fd, ...)
{
	struct fd f;
	int ret = -EBADF;

	f = fdget(fd);
	if (f.file) {
		ret = helper(f.file, ...);
		fdput(f();
	}

	return ret;
}

where io_uring will use helper(), and where the file reference is
assumed to be valid for helper() and helper() will not put a reference
to it.

That's a bit different than your putname() case, but I think as long as
it's consistent regardless of return value, then either approach is
fine. Maybe just add a comment about that? At least for the consistent
case, if it blows up, it'll blow up instantly rather than be a surprise
down the line for "case x,y,z doesn't put it" or "case x,y,z always puts
in, normal one does not".

> I really want to get rid of that ad-hoc crap.  If we are to have what
> amounts to the alternative syscall interface, we'd better get it
> right.  I'm perfectly fine with having a set of "this is what the
> syscall is doing past marshalling arguments" primitives, but let's
> make sure they are properly documented and do not have landmines for
> callers to step into...

Fully agree.

> Questions on the io_uring side:
> 	* you usually reject REQ_F_FIXED_FILE for ...at() at ->prep() time.
> Fine, but... what's the point of doing that in IORING_OP_FGETXATTR case?
> Or IORING_OP_GETXATTR, for that matter, since you pass AT_FDCWD anyway...
> Am I missing something subtle here?

Right, it could be allowed for fgetxattr on the io_uring side. Anything
that passes in a struct file would be fair game to enable it on.
Anything that passes in a path (eg a non-fd value), it obviously
wouldn't make sense anyway.

> 	* what's to guarantee that pointers fetched by io_file_get_fixed()
> called from io_assing_file() will stay valid?  You do not bump the struct
> file refcount in this case, after all; what's to prevent unregistration
> from the main thread while the worker is getting through your request?
> Is that what the break on node->refs in the loop in io_rsrc_node_ref_zero()
> is about?  Or am I barking at the wrong tree here?  I realize that I'm about
> the last person to complain about the lack of documentation, but...
> 
> 	FWIW, my impression is that you have a list of nodes corresponding
> to overall resource states (which includes the file reference table) and
> have each borrow bump the use count on the node corresponding to the current
> state (at the tail of the list?)
> 	Each removal adds new node to the tail of the list, sticks the
> file reference there and tries to trigger io_rsrc_node_ref_zero() (which,
> for some reason, takes node instead of the node->ctx, even though it
> doesn't give a rat's arse about anything else in its argument).
> 	If there are nodes at the head of the list with zero use count,
> that takes them out, stopping at the first in-use node.  File reference
> stashed in a node is dropped when it's taken out.
> 
> 	If the above is more or less correct (and I'm pretty sure that it
> misses quite a few critical points), the rules would be equivalent to
> 	+ there is a use count associated with the table state.
> 	+ before we borrow a file reference from the table, we must bump
> that use count (see the call of __io_req_set_rsrc_node() in
> io_file_get_fixed()) and arrange for dropping it once we are done with
> the reference (io_put_rsrc_node() when freeing request, in io_free_batch_list())
> 	+ any removals from the table will switch to new state; dropping
> the removed reference is guaranteed to be delayed until use counts on
> all earlier states drop to zero.
> 
> 	How far are those rules from being accurate and how incomplete
> they are?  I hadn't looked into the quiescence-related stuff, which might
> or might not be relevant...

That is pretty darn accurate. The ordering of the rsrc nodes and the
break ensure that it stays valid until anything using it has completed.
And yes it would be nice to document that code a bit, but honestly I'd
much rather just make it more obviously referenced if that can be done
cheaply enough. For now, I'll add some comments, and hope you do the
same on your side! Because I don't ever remember seeing an Al comment.
Great emails, for sure, but not really comments.

-- 
Jens Axboe

