Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9F5739A511
	for <lists+io-uring@lfdr.de>; Thu,  3 Jun 2021 17:55:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbhFCP4n (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Jun 2021 11:56:43 -0400
Received: from sonic311-30.consmr.mail.ne1.yahoo.com ([66.163.188.211]:35926
        "EHLO sonic311-30.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229925AbhFCP4i (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Jun 2021 11:56:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1622735693; bh=VtRRp+zjFaqIB6GYcK6EeHCLd2nDbeCY1Adz43lgg4o=; h=Subject:To:Cc:References:From:Date:In-Reply-To:From:Subject:Reply-To; b=tZazLXERyxNW9H23jJh7nlN9h8s2UaJBB97RU0k3uXBmLsLzKjyPVLsLmEEo6nrtoM/aNx5FdntEOxA6gwFt7vIfP4PDnoe3hdaObfj68ER44ZieoG7qze7dCQwvp0K6jANwiRxA4tlAmLL0mylNes2G5sdO4rZ9OXqe7j6PDt0ss0YNCQcnJZZMJA3dRtxCSDXsQTBsxLt4Z/CqhrWoAKljBmMB1GEmU0GGEDfUa8f0JK5xZdlj9CPvb2ZSQibrOp66sroblnFTSQ2vbhns2vX3qtfYkCvzxzRFdCM+sliPPMBtKutBC179FXH2FhIUMFKGrS/rdvTQzGmQQT5Kzw==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1622735693; bh=jOZ1SN77OqcKQU+X/CAVbbBHxDRKYY1BryVkNALIm5y=; h=X-Sonic-MF:Subject:To:From:Date:From:Subject; b=Hor7UJSBwwmcLFCohXmS99lPTy4Du9iO01QTZsMfp4Pfnf+u8XL0aOZT4CcSelp90+tNAjSXVIGXIanoDRvaByt0cJ+jabVJahLOuIfbOvBkBa3UCno1eOWPxKRPOP3KPp5kWxPT4naiLJPgpXfAKW9upcsfVOWeURtSPPOT/kL6u3gbuSFrA/os+zfMcBWzvTHsXthTRhByiMYXbhSXC2i/p3a43L09qeBcTkX5/qKCAY7sxEvzJoPUXLLppiBcIkiu2dpkmB0FUkJuK5WFqEIY+yBiWmUaW48zOHzsfa3T7CQRfgVGASfEh8pEL3CdbSA0frphmGGFg+fXzH6ZLQ==
X-YMail-OSG: yATj0x4VM1lTea7xO8kTMg9DOWyhgeItCiM_a_7z8CxAP1yX2IlDJeZma53ddkn
 GvXX9G_29BCM0wCMDGnBTV3SXbkU_V6p4oObxUcQGh2T0_GLu8B6mwIBlJcqHeL1N_vyCy_tcO_w
 JKYSDeXpMsg_x73V8TJ963UMjo.B49JG8lATHD9_YpJMaZoEpnSuD2yfZgBCgmaLcPqxZ1YJd9A8
 HpVFDHWvyOwCLWmehsyyRkJxDTHjyoluq0DYWbVJDQKAENImycQo2QbT7TZOfcoEJd7IdYEJbxvI
 t3J9lp_iJJHdxIQYqvExe9D86D3rkE4_FUbyNGr1rLj0N5Xz02YdEMuDbwpfwZZE2B6J8PH9B3o9
 hCkD23lQkPmnkDFPhORbZlPYzIhN1XU3UN3ipRxHVjsl7J65gGR2iMpBZfbJKHTlK6ol_RMXxiG1
 hEpCkpFxMRHjhOEmipTA6mjWlAsy7AaT.q7e3qiqbln_1mTE4jn2oQMpl8ZJKnVuLXxkCSWnuy7H
 OLu2grLGfLlqTN_qUkvZEHGg.TDFskpr3.05LANfFvubtFF19i._gsT358.kNZZsK2Es2xbdrLRP
 cZT8XGQd0dRAlTPQa9sIoHwl1DHbQ9GKFyS7pySSlYkPL8XHDjWvvtICYvzYy17aK4MJCHNJSfdQ
 zVcm5Qd0A4iP9Kect9Lg8VlDbB3AbC..An2W5Vpye4KMIQkBYi5QzH7NMNoRhvwNIfCGWwKvvIah
 dIFiv5pYQl19E0umT3crgBetqpPYuhhcE5Fg8twqG9odDEdo9GT5v2.7spHCh4R_.BY4G5mK.bMA
 s8krbby.mEr9xKmlSKBfVBk..hmJiX.il0fYqU.7j6.vxov1Im1aFy0LxS4O7soLJG06HqQY0K51
 v9w35_Ssq7pr8zIR9QY9XEIn60shWXmK9gWRFtSxQ.OEJ2bL1ft6C3gZl2DgY6mVBWzhrwqDGPdk
 hyaoxHQnT0SsHCyxcDWHWVJhxpdQikq4jyLh75mUs_aGx7U6NqOVVX6jKnJbZKI6WsKouCR3CSus
 E_1pFAypNi3.CvZI_aS9nzuPfQGqqfirkX_sRtGac7QIcUmQH9SZcCTWE59HLC7LMv6.vvPf6NNi
 Sq44gbnZN.xMs.fQHVQx4OTtz3j3KDbTmyluTDRt0h.1jyxCCdMSn3KPDU1c_omTuJNeVi091fkj
 5ZRizD.RbzCUFF8Jx9walmo2qO_d_x1lJ9ZXLjMq00knYNJqonC_yc69APPTP2Cxa14O0szBPpWn
 Yp5H7bzuMeCnNCAhuRHmgmslJuKPFwQssGoivZLpF4f3tg6pibp2B3B3nAI1UPAs1Vf3Kni.trSC
 1hQgUu2QKWEca8c.gbbmfADzRMI9s8dVTOXIr.0hdYbE4eRnoQgBTskznIcsM5mTwfjPxM4oQ36K
 .jfsw2BrLqoUc7uoSZpJyyw1p5JtB5goGqlp2MEGO7oIt5QWRFZ8VFc9_Y1Y.wsdOK0DkEubp4CJ
 MDy0CfFkJuWM7mr_NUo8uVr57FQiWX2QdcgmE3v5sUpeof2mozMDW4fdR4ujj82JqZLFg800H4rK
 Nte2YEF8y.TsFNJPpSzFukRjCHoLWbsT.akEF0uoVr2US7FU0onl8pcUJaDGNAYKhr5exGIOUwAb
 _EUwVGTOJtxxuAvv2dSiVECjcKFtjynLYb1dmwIrp1hjoLi0IABhcoTKIh.coV4EwL1aO70B4iwt
 b_Yily0xCnVn3QHUB8jOuzCkShb3S1F3wfAhio5Wa1O3XL3GBIMU6z8ihyJ81ZgASDZDI8gDoTkw
 U7UaS9Me0nWltibuY70GPCtrRHcvhjMk2_owCNj2obNj0bDpYo7BhkAgfCnATBdc1.MlH9p15vxX
 4nBrXpw5FrAYc14Lx.pSVPKG7JyEK_GsWY5WI15RVmenULfD7FSB3J59afKAZevfbSHma5w3jZRl
 PCTSmWUfYpBEdGN76BH6iqD7trdnoHsOtbLcQc3BielEr53U0FWivNyzta7KYxF0sGsk..wySF9C
 C5xnW9Y.kU_xF9bEYYEzeNCntOSvsA55cNxGMI.b82fTkFlXHDRrf1Ow6eceha_XswzZrWkFaRSN
 eXAOxFAJo4AieiWoPht0h6SNlpuzha0X12n7IQu5D4ZlMGpOzPZ8_i7jISwpUhMeTwCI4u5_Uxrx
 yQkilmEJpP_5IPoc73JWvV4UH6mhTlUqFGxuVFqcqU_Zzy2ka6WeOLnwK0W00M.RvUM9mVqqH5A_
 4NMnFZ4HO2_vttJbFClnRXIPbVUKNeyraSHv_HNUtAmnpe6XDLAr8YV.AUlySBDJA.biUABtbM.I
 c6TQ6lKLuXkWTz1xByT069fMRNmifj7vWLQ.JrBzZSM3X6x0w489g1bOSsywjXZrk1vtRq66TZjK
 Lcu5EDEeLZ5UXE4Rq.t_mCMsJip6Tt1eHkc5B.IvZPbrpZBKvqN2llpBVgOAN9r9niRLunruH1Y5
 gtgLtOFCGT7.XbWKs4CWGR5.AmCv13pFxG7LPGhy7QgRJGVgDembcGfMzOn_cmbvKqJ1zgwHWOnj
 bh3REC7_S9J7qMRo0FrfYctu_GYGuN8X0ZHYbhPY1FwlIRvkrNjbPcMqQrmvrnrDH_5Ft3tgva42
 zz6B6qmjgbyNAQ_bhGvt78HG8wh8RiEi.xNi7HnI8F1GAtT.AOj99F0EVGVx3e1vUQT8OAwP195u
 F.7dK_..bzOyMMcvUzj7u4aL_KI7UVuUU1bqYQFy_cbwWkmp4i.yexG_RUWOl9CqG9judxprHQlu
 Zfhmo5m04W5q5A91Yehyamew2QTsLYBs7qI2DM54e33Idoc_RyPfyax8q3xa0YnL1rRLM09OXM5.
 UkNeHfHjHgPhPdNTVJZSoPadf19TlxVs4CUA8s46D9ZcWPC2vBz1ooXr3Bhf4W9S4sOaLv_JiDva
 ig.0h_F3i3NpnwiD5UhqwEocOaxTHBanM.pT2Kwvh3Jz23Vk__vQ4BJxTgVPkplP9xqWJKGmllKi
 m0uE50wUj6yKsWMT_v59BYdoQcbIcTEIanaeS6Ei0Ay8GVwNVIvEq8xli7vW84AZLrIrzGnU9CRh
 gueleCqOgUyzlGCPUXlZVe.U.XC_.IAlm3trw81TdsFd5jmkD9M2X5hxHgWNLdOzYJooyJSbapWP
 xd4VPyWTprMULANXG.jT74PuWaH3.MVeMtci8.YcagioTr4CZ30FdIxpE3kEgLqUBBfE7IwWqUCf
 PmWaYFxFibZi4UT..ryy.dkJuEboULfa9_Ms-
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic311.consmr.mail.ne1.yahoo.com with HTTP; Thu, 3 Jun 2021 15:54:53 +0000
Received: by kubenode550.mail-prod1.omega.bf1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID a82d5df94069920905cb2855a7ad4325;
          Thu, 03 Jun 2021 15:54:51 +0000 (UTC)
Subject: Re: [RFC PATCH 2/9] audit,io_uring,io-wq: add some basic audit
 support to io_uring
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Paul Moore <paul@paul-moore.com>
Cc:     Jens Axboe <axboe@kernel.dk>, selinux@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-audit@redhat.com,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Casey Schaufler <casey@schaufler-ca.com>
References: <162163367115.8379.8459012634106035341.stgit@sifl>
 <CAHC9VhRjzWxweB8d8fypUx11CX6tRBnxSWbXH+5qM1virE509A@mail.gmail.com>
 <162219f9-7844-0c78-388f-9b5c06557d06@gmail.com>
 <CAHC9VhSJuddB+6GPS1+mgcuKahrR3UZA=1iO8obFzfRE7_E0gA@mail.gmail.com>
 <8943629d-3c69-3529-ca79-d7f8e2c60c16@kernel.dk>
 <CAHC9VhTYBsh4JHhqV0Uyz=H5cEYQw48xOo=CUdXV0gDvyifPOQ@mail.gmail.com>
 <9e69e4b6-2b87-a688-d604-c7f70be894f5@kernel.dk>
 <3bef7c8a-ee70-d91d-74db-367ad0137d00@kernel.dk>
 <fa7bf4a5-5975-3e8c-99b4-c8d54c57da10@kernel.dk>
 <a7669e4a-e7a7-7e94-f6ce-fa48311f7175@kernel.dk>
 <CAHC9VhSKPzADh=qcPp7r7ZVD2cpr2m8kQsui43LAwPr-9BNaxQ@mail.gmail.com>
 <b20f0373-d597-eb0e-5af3-6dcd8c6ba0dc@kernel.dk>
 <CAHC9VhRZEwtsxjhpZM1DXGNJ9yL59B7T_p2B60oLmC_YxCrOiw@mail.gmail.com>
 <CAHC9VhSK9PQdxvXuCA2NMC3UUEU=imCz_n7TbWgKj2xB2T=fOQ@mail.gmail.com>
 <94e50554-f71a-50ab-c468-418863d2b46f@gmail.com>
 <CAHC9VhS7Vhby4YR94U2YOwMtva-rc=_ifRcZYi1YVPwfi+Xuzg@mail.gmail.com>
 <41bc1351-b07b-d9de-f7e3-8c58be14ba9f@gmail.com>
From:   Casey Schaufler <casey@schaufler-ca.com>
Message-ID: <16c182bf-22a1-c9e6-8a70-ffc7473af119@schaufler-ca.com>
Date:   Thu, 3 Jun 2021 08:54:48 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <41bc1351-b07b-d9de-f7e3-8c58be14ba9f@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Mailer: WebService/1.1.18368 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/3/2021 3:51 AM, Pavel Begunkov wrote:
> On 6/2/21 8:46 PM, Paul Moore wrote:
>> On Wed, Jun 2, 2021 at 4:27 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>> On 5/28/21 5:02 PM, Paul Moore wrote:
>>>> On Wed, May 26, 2021 at 4:19 PM Paul Moore <paul@paul-moore.com> wrote:
>>>>> ... If we moved the _entry
>>>>> and _exit calls into the individual operation case blocks (quick
>>>>> openat example below) so that only certain operations were able to be
>>>>> audited would that be acceptable assuming the high frequency ops were
>>>>> untouched?  My initial gut feeling was that this would involve >50% of
>>>>> the ops, but Steve Grubb seems to think it would be less; it may be
>>>>> time to look at that a bit more seriously, but if it gets a NACK
>>>>> regardless it isn't worth the time - thoughts?
>>>>>
>>>>>   case IORING_OP_OPENAT:
>>>>>     audit_uring_entry(req->opcode);
>>>>>     ret = io_openat(req, issue_flags);
>>>>>     audit_uring_exit(!ret, ret);
>>>>>     break;
>>>> I wanted to pose this question again in case it was lost in the
>>>> thread, I suspect this may be the last option before we have to "fix"
>>>> things at the Kconfig level.  I definitely don't want to have to go
>>>> that route, and I suspect most everyone on this thread feels the same,
>>>> so I'm hopeful we can find a solution that is begrudgingly acceptable
>>>> to both groups.
>>> May work for me, but have to ask how many, and what is the
>>> criteria? I'd think anything opening a file or manipulating fs:
>>>
>>> IORING_OP_ACCEPT, IORING_OP_CONNECT, IORING_OP_OPENAT[2],
>>> IORING_OP_RENAMEAT, IORING_OP_UNLINKAT, IORING_OP_SHUTDOWN,
>>> IORING_OP_FILES_UPDATE
>>> + coming mkdirat and others.
>>>
>>> IORING_OP_CLOSE? IORING_OP_SEND IORING_OP_RECV?
>>>
>>> What about?
>>> IORING_OP_FSYNC, IORING_OP_SYNC_FILE_RANGE,
>>> IORING_OP_FALLOCATE, IORING_OP_STATX,
>>> IORING_OP_FADVISE, IORING_OP_MADVISE,
>>> IORING_OP_EPOLL_CTL
>> Looking quickly at v5.13-rc4 the following seems like candidates for
>> auditing, there may be a small number of subtractions/additions to
>> this list as people take a closer look, but it should serve as a
>> starting point:
>>
>> IORING_OP_SENDMSG
>> IORING_OP_RECVMSG
>> IORING_OP_ACCEPT
>> IORING_OP_CONNECT
>> IORING_OP_FALLOCATE
>> IORING_OP_OPENAT
>> IORING_OP_CLOSE
>> IORING_OP_MADVISE
>> IORING_OP_OPENAT2
>> IORING_OP_SHUTDOWN
>> IORING_OP_RENAMEAT
>> IORING_OP_UNLINKAT
>>
>> ... can you live with that list?
> it will bloat binary somewhat, but considering it's all in one
> place -- io_issue_sqe(), it's workable.
>
> Not nice to have send/recv msg in the list, but I admit they
> may do some crazy things. What can be traced for them?

Both SELinux and Smack do access checks on packet operations.
As access may be denied by these checks, audit needs to be available.
This is true for UDS, IP and at least one other protocol family.

>  Because
> at the moment of issue_sqe() not everything is read from the
> userspace.
>
> see: io_sendmsg() { ...; io_sendmsg_copy_hdr(); },
>
> will copy header only in io_sendmsg() in most cases, and
> then stash it for re-issuing if needed.
>
>
>>> Another question, io_uring may exercise asynchronous paths,
>>> i.e. io_issue_sqe() returns before requests completes.
>>> Shouldn't be the case for open/etc at the moment, but was that
>>> considered?
>> Yes, I noticed that when testing the code (and it makes sense when you
>> look at how io_uring handles things).  Depending on the state of the
>> system when the io_uring request is submitted I've seen both sync and
>> async io_uring operations with the associated different calling
>> contexts.  In the case where io_issue_sqe() needs to defer the
>> operation to a different context you will see an audit record
>> indicating that the operation failed and then another audit record
>> when it completes; it's actually pretty interesting to be able to see
>> how the system and io_uring are working.
> Copying a reply to another message to keep clear out
> of misunderstanding.
>
> "io_issue_sqe() may return 0 but leave the request inflight,
> which will be completed asynchronously e.g. by IRQ, not going
> through io_issue_sqe() or any io_read()/etc helpers again, and
> after last audit_end() had already happened.
> That's the case with read/write/timeout, but is not true for
> open/etc."
>
> And there is interest in async send/recv[msg] as well (via
> IRQ as described, callbacks, etc.).
>  
>> We could always mask out these delayed attempts, but at this early
>> stage they are helpful, and they may be useful for admins.
>>
>>> I don't see it happening, but would prefer to keep it open
>>> async reimplementation in a distant future. Does audit sleep?
>> The only place in the audit_uring_entry()/audit_uring_exit() code path
>> that could sleep at present is the call to audit_log_uring() which is
>> made when the rules dictate that an audit record be generated.  The
>> offending code is an allocation in audit_log_uring() which is
>> currently GFP_KERNEL but really should be GFP_ATOMIC, or similar.  It
>> was a copy-n-paste from the similar syscall function where GFP_KERNEL
>> is appropriate due to the calling context at the end of the syscall.
>> I'll change that as soon as I'm done with this email.
> Ok, depends where it steers, but there may be a requirement to
> not sleep for some hooks because of not having a sleepable context.
>
>> Of course if you are calling io_uring_enter(2), or something similar,
>> then audit may sleep as part of the normal syscall processing (as
>> mentioned above), but that is due to the fact that io_uring_enter(2)
>> is a syscall and not because of anything in io_issue_sqe().
>>
