Return-Path: <io-uring+bounces-2780-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 58BA2953D49
	for <lists+io-uring@lfdr.de>; Fri, 16 Aug 2024 00:17:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E2AEA1F21667
	for <lists+io-uring@lfdr.de>; Thu, 15 Aug 2024 22:17:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09F2E1547CC;
	Thu, 15 Aug 2024 22:17:40 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from cloud48395.mywhc.ca (cloud48395.mywhc.ca [173.209.37.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53B6A15445D
	for <io-uring@vger.kernel.org>; Thu, 15 Aug 2024 22:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.209.37.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723760259; cv=none; b=AW8blExhxYnW6Y4Y1kwasO/K07KAR3tb4CIvDfc3iY5/qsyxaeDDW8cp/mkPTFnE5h3zvEGCIEyxEIUButRTzGMSJf/Yupn1DEEtcqrOhBYuXi1MjJ6kjRbR+T9P71YtqSalrCX4LaJ3V6QWgwArOQYwelJtYqSZAuoXspL6018=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723760259; c=relaxed/simple;
	bh=JbzgOExFXSf1lPhO3rZsp4vurUghx+WDBaDaDxgqas8=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Yo6EG8k3zuKQVimW9+pblVPVF12D/GhlWiA23NwuG/9AAXc6d3HVSLbgFySimdiJ/5sT975sTS3A/0DddquRNvnRsrk54c98p0FA3+RCJ1/vmku2LjeJD8IQ2zZZhODMe/0BD+Rnl0Re+1+dnrutjeF1VQQdGJSyoaSpbilI5Zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com; spf=pass smtp.mailfrom=trillion01.com; arc=none smtp.client-ip=173.209.37.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trillion01.com
Received: from [45.44.224.220] (port=57250 helo=[192.168.1.177])
	by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96.2)
	(envelope-from <olivier@trillion01.com>)
	id 1seimg-0002Bw-0I;
	Thu, 15 Aug 2024 18:17:30 -0400
Message-ID: <f899f21be48509d72ed8a1955061bef98512fab4.camel@trillion01.com>
Subject: Re: [PATCH 0/2] abstract napi tracking strategy
From: Olivier Langlois <olivier@trillion01.com>
To: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
	io-uring@vger.kernel.org
Date: Thu, 15 Aug 2024 18:17:29 -0400
In-Reply-To: <631b17e3-0c95-4313-9a07-418cd1a248b7@kernel.dk>
References: <cover.1723567469.git.olivier@trillion01.com>
	 <c614ee28-eeb2-43bd-ae06-cdde9fd6fee2@kernel.dk>
	 <a818bc04dfdcdbacf7cc6bf90c03b8a81d051328.camel@trillion01.com>
	 <631b17e3-0c95-4313-9a07-418cd1a248b7@kernel.dk>
Autocrypt: addr=olivier@trillion01.com; prefer-encrypt=mutual;
 keydata=mQINBFYd0ycBEAC53xedP1NExPwtBnDkVuMZgRiLmWoQQ8U7vEwt6HVGSsMRHx9smD76i
 5rO/iCT6tDIpZoyJsTOh1h2NTn6ZkoFSn9lNOJksE77/n7HNaNxiBfvZHsuNuI53CkYFix9JhzP3t
 g5nV/401re30kRfA8OPivpnj6mZhU/9RTwjbVPPb8dPlm2gFLXwGPeDITgSRs+KJ0mM37fW8EatJs
 0a8J1Nk8wBvT7ce+S2lOrxDItra9pW3ukze7LMirwvdMRC5bdlw2Lz03b5NrOUq+Wxv7szn5Xr9f/
 HdaCH7baWNAO6H/O5LbJ3zndewokEmKk+oCIcXjaH0U6QK5gJoO+3Yt5dcTo92Vm3VMxzK2NPFXgp
 La7lR9Ei0hzQ0zptyFFyftt9uV71kMHldaQaSfUTsu9dJbnS2kI/j+F2S1q6dgKi3DEm0ZRGvjsSG
 rkgPJ5T16GI1cS2iQntawdr0A1vfXiB9xZ1SMGxL/l6js9BVlIx/CBGOJ4L190QmxJlcAZ2VnQzrl
 ramRUv01xb00IPJ5TBft5IJ+SY0FnY9pIERIl6w9khwLt/oGuKNmUHmzJGYoJHYfh72Mm8RQ1R/JS
 o6v85ULBGdEC3pQq1j//OPyH3egiXIwFq6BtULH5CvsxQkSqgj1MpjwfgVJ8VbjNwqwBXHjooEORj
 vFQqWQki6By3QARAQABtDJPbGl2aWVyIExhbmdsb2lzIChNeSBrZXkpIDxvbGl2aWVyQHRyaWxsaW
 9uMDEuY29tPokCNwQTAQgAIQUCVh3TJwIbAwULCQgHAwUVCgkICwUWAgMBAAIeAQIXgAAKCRBlaka
 GGsWHEI1AD/9sbj+vnFU29WemVqB4iW+9RrHIcbXI4Jg8WaffTQ8KvVeCJ4otzgVT2nHC2A82t4PF
 0tp21Ez17CKDNilMvOt8zq6ZHx36CPjoqUVjAdozOiBDpC4qB6ZKYn+gqSENO4hqmmaOW57wT9vII
 v6mtHmnFvgpOEJl6wbs8ArHDt0BLSjc8QQfvBhoKoWs+ijQTyvFGlQl0oWxEbUkR1J3gdft9Oj9xQ
 G4OFo73WaSEK/L9IalU2ulCBC+ucSP9McoDxy1i1u8HUDrV5wBY1zafc9zVBcMNH6+ZjxwQmZXqtz
 ATzB3RbSFHAdmvxl8q6MeS2yx7Atk0CXgW9z5k2KeuZhz5rVV5A+D19SSGzW11uYXsibZx/Wjr9xB
 KHB6U7qh5sRHaQS191NPonKcsXXAziR+vxwQTP7ZKfy+g5N/e6uivoUnQrl9uvUDDPXEpwVNSoVws
 Vn4tNyrGEdN11pHDbH5fSGzdpbY8+yczUoxMmsEQe/fpVwRBZUqafRn2TVUhV0qqzsUuQcTNw1zIZ
 JgvkqrHgd4ivd2b1bXBczmu/wMGpEnF6cWzSQDiwC1NF3i+gHCuD8IX1ujThWtzXsn0VtrMkrRCbn
 ponVQ6HcbRYYXPuK0HRRjCSuAKo5porVONepiOSmu0FBrpGqBkpBtLrzKXoi1yt/7a/wGdMcVhYGg
 vA==
Organization: Trillion01 Inc
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.4 
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cloud48395.mywhc.ca
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - trillion01.com
X-Get-Message-Sender-Via: cloud48395.mywhc.ca: authenticated_id: olivier@trillion01.com
X-Authenticated-Sender: cloud48395.mywhc.ca: olivier@trillion01.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 

On Tue, 2024-08-13 at 15:44 -0600, Jens Axboe wrote:
> On 8/13/24 3:25 PM, Olivier Langlois wrote:
> > On Tue, 2024-08-13 at 12:33 -0600, Jens Axboe wrote:
> > > On 8/13/24 10:44 AM, Olivier Langlois wrote:
> > > > the actual napi tracking strategy is inducing a non-negligeable
> > > > overhead.
> > > > Everytime a multishot poll is triggered or any poll armed, if
> > > > the
> > > > napi is
> > > > enabled on the ring a lookup is performed to either add a new
> > > > napi
> > > > id into
> > > > the napi_list or its timeout value is updated.
> > > >=20
> > > > For many scenarios, this is overkill as the napi id list will
> > > > be
> > > > pretty
> > > > much static most of the time. To address this common scenario,
> > > > a
> > > > new
> > > > abstraction has been created following the common Linux kernel
> > > > idiom of
> > > > creating an abstract interface with a struct filled with
> > > > function
> > > > pointers.
> > > >=20
> > > > Creating an alternate napi tracking strategy is therefore made
> > > > in 2
> > > > phases.
> > > >=20
> > > > 1. Introduce the io_napi_tracking_ops interface
> > > > 2. Implement a static napi tracking by defining a new
> > > > io_napi_tracking_ops
> > >=20
> > > I don't think we should create ops for this, unless there's a
> > > strict
> > > need to do so. Indirect function calls aren't cheap, and the CPU
> > > side
> > > mitigations for security issues made them worse.
> > >=20
> > > You're not wrong that ops is not an uncommon idiom in the kernel,
> > > but
> > > it's a lot less prevalent as a solution than it used to. Exactly
> > > because
> > > of the above reasons.
> > >=20
> > ok. Do you have a reference explaining this?
> > and what type of construct would you use instead?
>=20
> See all the spectre nonsense, and the mitigations that followed from
> that.
>=20
> > AFAIK, a big performance killer is the branch mispredictions coming
> > from big switch/case or if/else if/else blocks and it was precisely
> > the
> > reason why you removed the big switch/case io_uring was having with
> > function pointers in io_issue_def...
>=20
> For sure, which is why io_uring itself ended up using indirect
> function
> calls, because the table just became unwieldy. But that's a different
> case from adding it for just a single case, or two. For those, branch
> prediction should be fine, as it would always have the same outcome.
>=20
> > I consumme an enormous amount of programming learning material
> > daily
> > and this is the first time that I am hearing this.
>=20
> The kernel and backend programming are a bit different in that
> regard,
> for better or for worse.
>=20
> > If there was a performance concern about this type of construct and
> > considering that my main programming language is C++, I am bit
> > surprised that I have not seen anything about some problems with
> > C++
> > vtbls...
>=20
> It's definitely slower than a direct function call, regardless of
> whether this is in the kernel or not. Can be mitigated by having the
> common case be predicted with a branch. See INDIRECT_CALL_*() in the
> kernel.
>=20
> > but oh well, I am learning new stuff everyday, so please share the
> > references you have about the topic so that I can perfect my
> > knowledge.
>=20
> I think lwn had a recent thing on indirect function calls as it
> pertains
> to the security modules, I'd check that first. But the spectre thing
> above is likely all you need!
>=20

Jens,

thx a lot about the clarifications. I will for sure investigate these
leads to better understand your fear of function callbacks...

I have little interest about Spectre and other mitigations and security
in general so I know very little about those topics.

A guy, that I value a lot his knowledge is Chandler Carruth from Google
who made a talk about Spectre in 2018:
https://www.youtube.com/watch?v=3D_f7O3IfIR2k

I will rewatch his talk, check LWN about the indirect functions calls
INDIRECT_CALL() macros that you mention...

AFAIK, the various kernel mitigations are mostly applied when
transiting from Kernel mode back to userspace.

because otherwise the compiled code for a usespace program would be
pretty much identical than kernel compiled code.

To my eyes, what is really important, it is that absolute best
technical solution is choosen and the only way that this discussion can
be done, it is with numbers. So I have created a small created a small
benchmark program to compare a function pointer indirect call vs
selecting a function in a 3 branches if/else if/else block. Here are
the results:

----------------------------------------------------------
Benchmark                Time             CPU   Iterations
----------------------------------------------------------
BM_test_virtual      0.628 ns        0.627 ns    930255515
BM_test_ifElse        1.59 ns         1.58 ns    446805050

add this result with my concession in
https://lore.kernel.org/io-uring/f86da1b705e98cac8c72e807ca50d2b4ce3a50a2.c=
amel@trillion01.com/

that you are right for 2 of the function pointers out of the 3
functions of io_napi_tracking_ops...

Hopefully this discussion will lead us toward the best solution.

keep in mind that this point is a minuscule issue.

if you prefer the 2.5x slower construct for any reason that you do not
have to justify, I'll accept your decision and rework my proposal to go
your way.

I believe that offering some form of NAPI static tracking is still a
very interesting feature no matter what is the outcome for this very
minor technical issue.

code:
/*
 * virtual overhead vs if/else google benchmark
 *
 * Olivier Langlois - August 15, 2024
 *
 * compile cmd:
 * g++ -std=3Dc++26 -I.. -pthread -Wall -g -O3 -pipe
 * -fno-omit-frame-pointer bench_virtual.cpp -lbenchmark -o
bench_virtual
 */

#include "benchmark/benchmark.h"

/*
 * CppCon 2015: Chandler Carruth "Tuning C++: Benchmarks, and CPUs, and
 * Compilers! Oh My!
 * https://www.youtube.com/watch?v=3DnXaxk27zwlk
 */
static void escape(void *p)
{
    asm volatile("" : : "g"(p) : "memory");
}

bool no_tracking_do_busy_loop()
{
    int res{0};

    escape(&res);
    return res;
}

bool dynamic_tracking_do_busy_loop()
{
    int res{1};

    escape(&res);
    return res;
}

bool static_tracking_do_busy_loop()
{
    int res{2};

    escape(&res);
    return res;
}

class io_napi_tracking_ops
{
public:
    virtual bool do_busy_loop() noexcept =3D 0;
};

class static_tracking_ops : public io_napi_tracking_ops
{
public:
    bool do_busy_loop() noexcept override;
};

bool static_tracking_ops::do_busy_loop() noexcept
{
    return static_tracking_do_busy_loop();
}

bool testVirtual(io_napi_tracking_ops *ptr)
{
    return ptr->do_busy_loop();
}

bool testIfElseDispatch(int i)
{
    if (i =3D=3D 0)
        return no_tracking_do_busy_loop();
    else if (i =3D=3D 1)
        return dynamic_tracking_do_busy_loop();
    else
        return static_tracking_do_busy_loop();
}

void BM_test_virtual(benchmark::State &state)
{
    static_tracking_ops vObj;
    volatile io_napi_tracking_ops *ptr =3D &vObj;

    for (auto _ : state) {
        benchmark::DoNotOptimize(testVirtual(
            const_cast<io_napi_tracking_ops *>(ptr)));
    }
}

void BM_test_ifElse(benchmark::State &state)
{
    volatile int i =3D 2;

    for (auto _ : state) {
        benchmark::DoNotOptimize(testIfElseDispatch(i));
    }
}

BENCHMARK(BM_test_virtual);
BENCHMARK(BM_test_ifElse);
BENCHMARK_MAIN();


