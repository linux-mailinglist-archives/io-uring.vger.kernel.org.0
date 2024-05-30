Return-Path: <io-uring+bounces-1997-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D3AC8D4B4F
	for <lists+io-uring@lfdr.de>; Thu, 30 May 2024 14:09:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DF5A5B237A9
	for <lists+io-uring@lfdr.de>; Thu, 30 May 2024 12:09:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B955F179955;
	Thu, 30 May 2024 12:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fastmail.fm header.i=@fastmail.fm header.b="3KyBIhXd";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="D4TNi1vK"
X-Original-To: io-uring@vger.kernel.org
Received: from fhigh5-smtp.messagingengine.com (fhigh5-smtp.messagingengine.com [103.168.172.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E74317966D;
	Thu, 30 May 2024 12:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717070976; cv=none; b=s/fm+3AvzTPXHhRq4D1dPd4kXVSBfXUguQvRd9ozTRxNq4XNFeGd9P1VEdVg9+qTEnVUJBnrvreJyurZxNEJVBiI+uHAIjKStN1I1JYl3/0ukJ7SWp3VAiVbIZcY/qaDA2TbV/i9hrd4yqx/1tz18EDv+bSoPz/XsWmRG2389UQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717070976; c=relaxed/simple;
	bh=kiAcUElfysIHUfoTfWqAUUZZV3ZoCVJkKzw4US5vvcM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KH1PNwPK8rHPWInkVoco11Tz0AqKhTeF4dZOpSLDkAXwKFCIiCo6T136R2qU1RF/rvlhmBvvQzByXMzk7JDIwZ0p2h8QiCmgSwRzJi+h/v9emuzTGj07TV23zEsPIHetK/PRbQxKmZPw3zO+RxkcBLdwBX6ppkVw9d89MInhwlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.fm; spf=pass smtp.mailfrom=fastmail.fm; dkim=pass (2048-bit key) header.d=fastmail.fm header.i=@fastmail.fm header.b=3KyBIhXd; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=D4TNi1vK; arc=none smtp.client-ip=103.168.172.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.fm
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.fm
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
	by mailfhigh.nyi.internal (Postfix) with ESMTP id A04A81140239;
	Thu, 30 May 2024 08:09:30 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Thu, 30 May 2024 08:09:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.fm; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1717070970;
	 x=1717157370; bh=Rcpgxf7yUNYvpBMH0f93+H669i02dWQMV7juB+4+g68=; b=
	3KyBIhXdP9kNQqwzpt89PFN1Jf9qZ5zG/VKLHEpefCfilZ3NPYDCMzKGdd6P3ON9
	7S5P7rRPsenGLXQ4p99sMr3YXmpIhMYOmcdFg7MXq68/XPe2oj0LUBU8F/dgKEp8
	mljIKqerPCGQfjVzs07VHiRWMR0Tvxmh8FrrD6JyCARZWmABIhp6Nj8j/IIrFiQX
	+LLp/LLdmeWeDJEWlcHYZ2Ukg8Jd7sT+Hbs8sztRfFBGp1XmrSGmpm3yRLsK9Htl
	7e+T8t+eXsUWScdA0O+6wDS0JVR0EuKs3a5pJUlvhiU6M1z3fk6jE9dDugxRCuwG
	WB0L99SxHRl+/y672klfxQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1717070970; x=
	1717157370; bh=Rcpgxf7yUNYvpBMH0f93+H669i02dWQMV7juB+4+g68=; b=D
	4TNi1vK2jEiTV68yQj3cnBQVaTCSEMbr1qp968R7aKlUJ0NdfTWrBxE6paqNCmf5
	BoR20p3K8x2WTTCF5/imKWOKlewimXWd4w+wvHLWwgAaB5QaBQ18JJttbKG9uq8M
	cyJ2Aw4RKyFs7FVeiGfWBtHZr39LgrRmBuBHDRuSxLBa7xDDbJPs3G7vMMbHXE09
	OsOIzLuUyVfX3aRyywKVySsKFBxLXv9s/LcqzZF46D6wlVt2cW2UPMCrCVKTZiTU
	y1ztbONUDAn7LeMTk0xpnN6MoxdyDcYqvf1Qcp6tEngcA+y00fPbOhLRCaifKoQJ
	lg1nzRkUguesn9eFKlAwg==
X-ME-Sender: <xms:eWxYZkLaPUMOFkYwgiaylpvW6A0RYZGKbkvBL0HlTaA4h8f-EGq7Ag>
    <xme:eWxYZkJWO-yPGtpKu0UGpxVAT1l2kC2kZQyBxMDclMbzKMCFWkwFp8GYK7n_DRIU1
    ulETgjSaOIMYcTu>
X-ME-Received: <xmr:eWxYZkte-5yygC35bq3onJjGfuca9NH4VMJBpWxkla9Ugkrl4Ve5oL4s1r2q0B0Ks6DvOcJSTmueEFvqVAVjo1JFghrGRKeqolqPsiykIztB-zE5CmLy>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvledrvdekgedggeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepkfffgggfuffvvehfhfgjtgfgsehtkeertddtvdejnecuhfhrohhmpeeuvghr
    nhguucfutghhuhgsvghrthcuoegsvghrnhgurdhstghhuhgsvghrthesfhgrshhtmhgrih
    hlrdhfmheqnecuggftrfgrthhtvghrnhepveelledthfehheejtdegiefhteejgefhtedt
    feevvefggfdtgeeugeffhfegjeeinecuffhomhgrihhnpehlfihnrdhnvghtpdhkvghrnh
    gvlhdrohhrghdpghhithhhuhgsrdgtohhmpdhushgvnhhigidrohhrghenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsvghrnhgurdhstghhuh
    gsvghrthesfhgrshhtmhgrihhlrdhfmh
X-ME-Proxy: <xmx:eWxYZhb0xekrnpOOJHV8fvcSEMlVaWCmdYHBeq6bixlG39Yaxsd_YA>
    <xmx:eWxYZrZ1ILeUr3GylsmVNZdAQFbk3iQ5oHlRo3mhm66nfgWrgS1drw>
    <xmx:eWxYZtA-Qvv5ssaYOwad7UzLxrsiUoSSOrRr03hW9wbSE-6O1OnYjg>
    <xmx:eWxYZhYwATrnL4Mw16r1TRgmEgcTNIIuBx3SKpcXymq1CDUzERHP5Q>
    <xmx:emxYZpClJQVQQl0TFFyFaw1RH6C54BmSduF_s52dF_9qEmfgz1kpbgJg>
Feedback-ID: id8a24192:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 30 May 2024 08:09:28 -0400 (EDT)
Message-ID: <f41cd03f-52a8-40e3-b226-e1d8867d2264@fastmail.fm>
Date: Thu, 30 May 2024 14:09:26 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 00/19] fuse: fuse-over-io-uring
To: Amir Goldstein <amir73il@gmail.com>, Bernd Schubert <bschubert@ddn.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 Andrei Vagin <avagin@google.com>, io-uring@vger.kernel.org,
 Josef Bacik <josef@toxicpanda.com>
References: <20240529-fuse-uring-for-6-9-rfc2-out-v1-0-d149476b1d65@ddn.com>
 <CAOQ4uxjsjrmHHXd8B5xaBjfPZTZtHrFsNUmAmjBVMK3+t9aR1w@mail.gmail.com>
From: Bernd Schubert <bernd.schubert@fastmail.fm>
Content-Language: en-US, de-DE, fr
In-Reply-To: <CAOQ4uxjsjrmHHXd8B5xaBjfPZTZtHrFsNUmAmjBVMK3+t9aR1w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 5/30/24 09:07, Amir Goldstein wrote:
> On Wed, May 29, 2024 at 9:01 PM Bernd Schubert <bschubert@ddn.com> wrote:
>>
>> From: Bernd Schubert <bschubert@ddn.com>
>>
>> This adds support for uring communication between kernel and
>> userspace daemon using opcode the IORING_OP_URING_CMD. The basic
>> appraoch was taken from ublk.  The patches are in RFC state,
>> some major changes are still to be expected.
>>
>> Motivation for these patches is all to increase fuse performance.
>> In fuse-over-io-uring requests avoid core switching (application
>> on core X, processing of fuse server on random core Y) and use
>> shared memory between kernel and userspace to transfer data.
>> Similar approaches have been taken by ZUFS and FUSE2, though
>> not over io-uring, but through ioctl IOs
>>
>> https://lwn.net/Articles/756625/
>> https://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse.git/log/?h=fuse2
>>
>> Avoiding cache line bouncing / numa systems was discussed
>> between Amir and Miklos before and Miklos had posted
>> part of the private discussion here
>> https://lore.kernel.org/linux-fsdevel/CAJfpegtL3NXPNgK1kuJR8kLu3WkVC_ErBPRfToLEiA_0=w3=hA@mail.gmail.com/
>>
>> This cache line bouncing should be addressed by these patches
>> as well.
>>
>> I had also noticed waitq wake-up latencies in fuse before
>> https://lore.kernel.org/lkml/9326bb76-680f-05f6-6f78-df6170afaa2c@fastmail.fm/T/
>>
>> This spinning approach helped with performance (>40% improvement
>> for file creates), but due to random server side thread/core utilization
>> spinning cannot be well controlled in /dev/fuse mode.
>> With fuse-over-io-uring requests are handled on the same core
>> (sync requests) or on core+1 (large async requests) and performance
>> improvements are achieved without spinning.
>>
>> Splice/zero-copy is not supported yet, Ming Lei is working
>> on io-uring support for ublk_drv, but I think so far there
>> is no final agreement on the approach to be taken yet.
>> Fuse-over-io-uring runs significantly faster than reads/writes
>> over /dev/fuse, even with splice enabled, so missing zc
>> should not be a blocking issue.
>>
>> The patches have been tested with multiple xfstest runs in a VM
>> (32 cores) with a kernel that has several debug options
>> enabled (like KASAN and MSAN).
>> For some tests xfstests reports that O_DIRECT is not supported,
>> I need to investigate that. Interesting part is that exactly
>> these tests fail in plain /dev/fuse posix mode. I had to disabled
>> generic/650, which is enabling/disabling cpu cores - given ring
>> threads are bound to cores issues with that are no totally
>> unexpected, but then there (scheduler) kernel messages that
>> core binding for these threads is removed - this needs
>> to be further investigates.
>> Nice effect in io-uring mode is that tests run faster (like
>> generic/522 ~2400s /dev/fuse vs. ~1600s patched), though still
>> slow as this is with ASAN/leak-detection/etc.
>>
>> The corresponding libfuse patches are on my uring branch,
>> but need cleanup for submission - will happen during the next
>> days.
>> https://github.com/bsbernd/libfuse/tree/uring
>>
>> If it should make review easier, patches posted here are on
>> this branch
>> https://github.com/bsbernd/linux/tree/fuse-uring-for-6.9-rfc2
>>
>> TODO list for next RFC versions
>> - Let the ring configure ioctl return information, like mmap/queue-buf size
>> - Request kernel side address and len for a request - avoid calculation in userspace?
>> - multiple IO sizes per queue (avoiding a calculation in userspace is probably even
>>   more important)
>> - FUSE_INTERRUPT handling?
>> - Logging (adds fields in the ioctl and also ring-request),
>>   any mismatch between client and server is currently very hard to understand
>>   through error codes
>>
>> Future work
>> - notifications, probably on their own ring
>> - zero copy
>>
>> I had run quite some benchmarks with linux-6.2 before LSFMMBPF2023,
>> which, resulted in some tuning patches (at the end of the
>> patch series).
>>
>> Some benchmark results
>> ======================
>>
>> System used for the benchmark is a 32 core (HyperThreading enabled)
>> Xeon E5-2650 system. I don't have local disks attached that could do
>>> 5GB/s IOs, for paged and dio results a patched version of passthrough-hp
>> was used that bypasses final reads/writes.
>>
>> paged reads
>> -----------
>>             128K IO size                      1024K IO size
>> jobs   /dev/fuse     uring    gain     /dev/fuse    uring   gain
>>  1        1117        1921    1.72        1902       1942   1.02
>>  2        2502        3527    1.41        3066       3260   1.06
>>  4        5052        6125    1.21        5994       6097   1.02
>>  8        6273       10855    1.73        7101      10491   1.48
>> 16        6373       11320    1.78        7660      11419   1.49
>> 24        6111        9015    1.48        7600       9029   1.19
>> 32        5725        7968    1.39        6986       7961   1.14
>>
>> dio reads (1024K)
>> -----------------
>>
>> jobs   /dev/fuse  uring   gain
>> 1           2023   3998   2.42
>> 2           3375   7950   2.83
>> 4           3823   15022  3.58
>> 8           7796   22591  2.77
>> 16          8520   27864  3.27
>> 24          8361   20617  2.55
>> 32          8717   12971  1.55
>>
>> mmap reads (4K)
>> ---------------
>> (sequential, I probably should have made it random, sequential exposes
>> a rather interesting/weird 'optimized' memcpy issue - sequential becomes
>> reversed order 4K read)
>> https://lore.kernel.org/linux-fsdevel/aae918da-833f-7ec5-ac8a-115d66d80d0e@fastmail.fm/
>>
>> jobs  /dev/fuse     uring    gain
>> 1       130          323     2.49
>> 2       219          538     2.46
>> 4       503         1040     2.07
>> 8       1472        2039     1.38
>> 16      2191        3518     1.61
>> 24      2453        4561     1.86
>> 32      2178        5628     2.58
>>
>> (Results on request, setting MAP_HUGETLB much improves performance
>> for both, io-uring mode then has a slight advantage only.)
>>
>> creates/s
>> ----------
>> threads /dev/fuse     uring   gain
>> 1          3944       10121   2.57
>> 2          8580       24524   2.86
>> 4         16628       44426   2.67
>> 8         46746       56716   1.21
>> 16        79740      102966   1.29
>> 20        80284      119502   1.49
>>
>> (the gain drop with >=8 cores needs to be investigated)
> 

Hi Amir,

> Hi Bernd,
> 
> Those are impressive results!

thank you!


> 
> When approaching the FUSE uring feature from marketing POV,
> I think that putting the emphasis on metadata operations is the
> best approach.

I can add in some more results and probably need to redo at least the
metadata tests. I have all the results in google docs and in plain text
files, just a bit cumbersome maybe also spam to post all of it here.

> 
> Not the dio reads are not important (I know that is part of your use case),
> but I imagine there are a lot more people out there waiting for
> improvement in metadata operations overhead.

I think the DIO use case is declining. My fuse work is now related to
the DDN Infina project, which has a DLM - this will all go via cache and
notifications (into from/to client/server) I need to start to work on
that asap... I'm also not too happy yet about cached writes/reads - need
to find time to investigate where the limit is.

> 
> To me it helps to know what the current main pain points are
> for people using FUSE filesystems wrt performance.
> 
> Although it may not be uptodate, the most comprehensive
> study about FUSE performance overhead is this FAST17 paper:
> 
> https://www.usenix.org/system/files/conference/fast17/fast17-vangoor.pdf

Yeah, I had seen it. Just checking again, interesting is actually their
instrumentation branch

https://github.com/sbu-fsl/fuse-kernel-instrumentation

This should be very useful upstream, in combination with Josefs fuse
tracepoints (btw, thanks for the tracepoint patch Josef! I'm going to
look at it and test it tomorrow).


> 
> In this paper, table 3 summarizes the different overheads observed
> per workload. According to this table, the workloads that degrade
> performance worse on an optimized passthrough fs over SSD are:
> - many file creates
> - many file deletes
> - many small file reads
> In all these workloads, it was millions of files over many directories.
> The highest performance regression reported was -83% on many
> small file creations.
> 
> The moral of this long story is that it would be nice to know
> what performance improvement FUSE uring can aspire to.
> This is especially relevant for people that would be interested
> in combining the benefits of FUSE passthrough (for data) and
> FUSE uring (for metadata).

As written above, I can add a few more data. But if possible I wouldn't
like to concentrate on benchmarking - this can be super time consuming
and doesn't help unless one investigates what is actually limiting
performance. Right now we see that io-uring helps, fixing the other
limits is then the next step, imho.

> 
> What did passthrough_hp do in your patched version with creates?
> Did it actually create the files?

Yeah, it creates files, I think on xfs (or ext4). I had tried tmpfs
first, but it had issues with seekdir/telldir until recently - will
switch back to tmpfs for next tests.

> In how many directories?
> Maybe the directory inode lock impeded performance improvement
> with >=8 threads?

I don't think the directory inode lock is an issue - this should be one
(or more directories) per thread

Basically

/usr/lib64/openmpi/bin/mpirun \
            --mca btl self -n $i --oversubscribe \
            ./mdtest -F -n40000 -i1 \
                -d /scratch/dest -u -b2 | tee ${fname}-$i.out


(mdtest is really convenient for meta operations, although requires mpi,
recent versions are here (the initial LLNL project merged with ior).

https://github.com/hpc/ior

"-F"
Perform test on files only (no directories).

"-n" number_of_items
Every process will creat/stat/remove # directories and files

"-i" iterations
The number of iterations the test will run

"-u"
Create a unique working directory for each task

"-b" branching_factor
The branching factor of the hierarchical directory structure [default: 1].


(The older LLNL repo has a better mdtest README
https://github.com/LLNL/mdtest)


Also, regarding metadata, I definitely need to find time resume work on
atomic-open. Besides performance, there is another use case
https://github.com/libfuse/libfuse/issues/945. Sweet Tea Dorminy / Josef
also seem to need that.

> 
>>
>> Remaining TODO list for RFCv3:
>> --------------------------------
>> 1) Let the ring configure ioctl return information,
>> like mmap/queue-buf size
>>
>> Right now libfuse and kernel have lots of duplicated setup code
>> and any kind of pointer/offset mismatch results in a non-working
>> ring that is hard to debug - probably better when the kernel does
>> the calculations and returns that to server side
>>
>> 2) In combination with 1, ring requests should retrieve their
>> userspace address and length from kernel side instead of
>> calculating it through the mmaped queue buffer on their own.
>> (Introduction of FUSE_URING_BUF_ADDR_FETCH)
>>
>> 3) Add log buffer into the ioctl and ring-request
>>
>> This is to provide better error messages (instead of just
>> errno)
>>
>> 3) Multiple IO sizes per queue
>>
>> Small IOs and metadata requests do not need large buffer sizes,
>> we need multiple IO sizes per queue.
>>
>> 4) FUSE_INTERRUPT handling
>>
>> These are not handled yet, kernel side is probably not difficult
>> anymore as ring entries take fuse requests through lists.
>>
>> Long term TODO:
>> --------------
>> Notifications through io-uring, maybe with a separated ring,
>> but I'm not sure yet.
> 
> Is that going to improve performance in any real life workload?
> 


I'm rather sure that we at DDN will need it for our project with the
DLM. I have other priorities for now - once it comes up, adding
notifications over uring shouldn't be difficult.



Thanks,
Bernd

