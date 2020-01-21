Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B3A814461A
	for <lists+io-uring@lfdr.de>; Tue, 21 Jan 2020 21:54:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728748AbgAUUyF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 21 Jan 2020 15:54:05 -0500
Received: from mr85p00im-zteg06021501.me.com ([17.58.23.183]:33374 "EHLO
        mr85p00im-zteg06021501.me.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728741AbgAUUyF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 21 Jan 2020 15:54:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com;
        s=1a1hai; t=1579640044;
        bh=5Bfnr2D2DFxufh1EkJM/D1iRaVwyfPLC7MM3OvaqMRE=;
        h=Content-Type:From:Subject:Date:Message-Id:To;
        b=l9BlhIMStEALNllxL5Sxvd8XT/MhWnNtPaypPHm3eFKIYxI77zRcyyxvtCrVt0rUG
         iuTO1Dlea6L/l8BGtNwmpVWdJo/ukRGyvpyTZv4fQRwWunK/RvJl/a3qGXbm8tfjYi
         pTPViUD4ZLdcmr3CS0HCckCgRmTdYrzbrYAqa2ViuKvgw+7aXSDERt7KHc5b6Swnq9
         O7tcJ8BBCO4p6UqVBuUbkN6wxFAFDkql94ovVhr1GzPfRk5mD+NKj8arMQfT2rJQAJ
         YV1i0lde12rDh2ydbGjMOjm3Zv1Ida9OunByrF2VDiJDVTmL8Sv89tt5Lo93ujl/Uk
         rhs72Dxq5vYFQ==
Received: from [192.168.0.104] (athedsl-287950.home.otenet.gr [85.73.172.108])
        by mr85p00im-zteg06021501.me.com (Postfix) with ESMTPSA id 31528380E55;
        Tue, 21 Jan 2020 20:54:04 +0000 (UTC)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Mark Papadakis <markuspapadakis@icloud.com>
Mime-Version: 1.0 (1.0)
Subject: Re: Extending the functionality of some SQE OPs
Date:   Tue, 21 Jan 2020 22:54:01 +0200
Message-Id: <D27B080F-EF18-41FF-B132-2C23195FC45C@icloud.com>
References: <8ebf0463-34a2-3416-d7e8-a2be420b1b82@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>
In-Reply-To: <8ebf0463-34a2-3416-d7e8-a2be420b1b82@kernel.dk>
To:     Jens Axboe <axboe@kernel.dk>
X-Mailer: iPad Mail (17C54)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2020-01-17_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015 mlxscore=0
 mlxlogscore=727 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-2001210156
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



This sounds great. It may wind up being far more useful or important down th=
e road, and if this doesn=E2=80=99t bloat the CQE, that=E2=80=99s fantastic.=
=20

Thanks,
@markpapadakis

> On 21 Jan 2020, at 9:55 PM, Jens Axboe <axboe@kernel.dk> wrote:
>=20
> =EF=BB=BFOn 1/21/20 12:50 AM, Mark Papadakis wrote:
>> Would it make sense to extend the semantics of some OPS of specific
>> syscalls to, for example, return in the CQE more than just an int
>> (matching the semantics of the specific syscall they represent)?  For
>> example, the respective OP for accept/accept4 returns an int for error
>> or the fd of the accepted connection=E2=80=99s socket FD. But, given the
>> clean-room implementation of io_uring, this may be a good opportunity
>> to expand on it. Maybe there should be another field in the CQEs e.g
>>=20
>> union {
>>    int i32;
>>    uint64_t u64;
>>    // whatever makes sense
>> } ret_ex;
>>=20
>> Where the implementation of some OPs would access and set accordingly.
>> For example, the OP for accept could set ret_ex.i32 to 1 if there are
>> more outstanding FDs to be dequeued from the accepted connections
>> queue, so that the application should accept again thereby draining it
>> - as opposed to being woken up multiple times to do so. Other OPs may
>> take advantage of this for other reasons.
>>=20
>> Maybe it doesn=E2=80=99t make as much sense as I think it does, but if
>> anything, it could become very useful down the road, once more
>> syscalls(even OPs that are entirely new are not otherwise represent
>> existing syscalls?) are implemented(invented?).=20
>=20
> Would certainly be possible, I'd suggest using a union around cqe->flags
> for that. The flags are unused as-of now, so we could introduce a way to
> know if we're passing back flags or u32 worth of data instead. If we
> unionize res2 with flags and reserve the upper bit of flags to say
> "flags are valid" or something like that, then we get 31 bits of int
> that could be used to pass back extra information.
>=20
> --=20
> Jens Axboe
>=20

