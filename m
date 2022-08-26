Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 214785A2F94
	for <lists+io-uring@lfdr.de>; Fri, 26 Aug 2022 21:04:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237904AbiHZTEZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Aug 2022 15:04:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234932AbiHZTEY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Aug 2022 15:04:24 -0400
Received: from sonic302-28.consmr.mail.ne1.yahoo.com (sonic302-28.consmr.mail.ne1.yahoo.com [66.163.186.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E7FEA5721
        for <io-uring@vger.kernel.org>; Fri, 26 Aug 2022 12:04:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1661540662; bh=HW5ESJ2d1TlmAjTGj+fat2LUGkojEU6yBDOJ7Q+hUFk=; h=Date:Subject:To:Cc:References:From:In-Reply-To:From:Subject:Reply-To; b=AnU9izwkij3a3nom9IeVLo+yu1pUiKkoOmlPeVO34o+S1ntF80vFQdBEe7xaMFPPlq7MgTVmFjxX6k/awIv2xnG8Cb6/maGSkG/03s8vPsU9Z1H1nyMqAr/UW8e/7k74TOzRl5o5/3O6Ng5qP34z3g0pPKvdy6M4IwPzkSRe6hGQML/BNbBSjZ4XpKmOlhcpjBqSAiskq1/W3LhboojPcXCudhqZ383gnKvDNr+Iq77nDHBbsKKbOk65XloGwy3ePRFuzRVhb1Huz5CNGh9qlSzhZY21jNf8rSFNrOUzm7GHp0WXQJLHY3CHTeI44CcFeUpOCeOz3Sb37uSWVX6Okg==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1661540662; bh=a+atSZG+SfVIqt3Np/4cvmDTf6RlNi9o4j/h/6D79+m=; h=X-Sonic-MF:Date:Subject:To:From:From:Subject; b=lgYZ1DrIzF4fVX1rLtOhqCrvvT+HopJHUivjnTpcy4B3ERBCdcXGf1kb2bVbVZUloNfz8pGUAkRK5qfpH/ZkslGAeTWP20RPyiFk/uDdXZTM0tVpOJLTBFMj1rDMMQDLQHLTInCvMsVxrHpK+EmhwklIv36pd1qlEueXXs70e4oIaZK9NgafTKvDESQeRyLxlQXOv8d/jV+ck4X+l9/COzO/iSzcabfxBUWkUPyBLhXzt0yy0oo4l3239m6P6I4W0YV9AR+QMWjKVX9nwvpvMyUcoZ3rQJ5brsAKPiV7VgLLgAPJjF7IthjbMmABJexgyzHHXBbRHF42Id1t3phTVA==
X-YMail-OSG: yjD.CwkVM1kH6eE6L0MBwxBpy4YlrkkR458Ienrk3kdDQ.3uFyT_bPlH6kst6f1
 5_ccvHJojfSugHmxDxpZouCOCXy54UZATnKu2m69XE6pQPPpavLB.Ue7slL3S_92x11F6axE8R6d
 Kbwi29hldNstyGr4Lgb.iSxObzsro1wpYZknrHO_T6fBXKyHD6VuRvmlrgzaHntRT_6jmcLic9vE
 qq0XhSak.tepkwlxfKiVMsRPGfylk.o56t86Tmzv_PvQlnBHMENKyYjP1IrhZp8ohWTUVgYthL1O
 D.Vh9OavB4Ify4kwTgdpbXEvm6S0m.e0fHE1u6aB5fAiwEx7pqkJeG4z87BezPJIAIiNDiRmKtvI
 yB1aioYpYaGjZYc_.BOZLqaKcCDoXmSYiTyX1OV_VA532UaysNSPX9hCYmR2muKl5XHW1knafCPS
 0JxTgROB4GCSsDKP8MCBfi3_5sXRkAL.gK3BnItUhddLg9bHz9YBo.KuaqIoKfvaWbrQPaAF5gUe
 RxfNDguZXGH_Cf5uCjNLoYERrKyXbY1cwY7_B5BvxHw9Lcybw6hh8IKBMANeL8_nLu7UhXAG2fSM
 aiNeAD6O99D51vC43s5btbm8Z3NQ7CF1lMUfQPMfJsdYWtrpjTjKQajLLjjDqn1J1u3UU4f6pYKO
 oLn88rTAoTWjHlQXl2DHs3fBO8ifrWWzTWLqGyKUg69qLErau9QpL3alOMwXG35_Tstmmg6Ahooo
 sqReOMBZrd3o18cmkbWcjoa0kmo5DSAKXLCQLcBvQ4T77ajpD7MEBu0xfkr8E0zPGBKqCs9a.4wx
 kLkoSYZEblGcXCbMbhlaGeR6MI2CZKYi4o2OL01U9DhHnGz_aie8DWpRpzHTvNiVHgEZaLmVN_Od
 iCazWRgm04c_JiRfYxgW1mbDB7IXOuqsWPuof6u_meelsHx91oNEYli0XpHpmHJtbB7qDXarcDf3
 AiIksVqXMA5tp0XsUsIhZDH6QkEmGPWJrhhr7_qmIslvgDBcYW7utC0GiAgza2NrFYMBQ9txvirC
 yyZGkAvt3.qe03Li5CuI60kK1_pUAtik2yTgEOJQqeshRG1hWFeDRRjqb.Ft9lEYxe21jx3rSmNc
 63do.9mSIgJsVOE2zOvpiQMAFuS7U41HzFM7CvjE5qgin1AAh_NPoK.bdYPdG3AW6hLbU8M4wqWV
 3cfsACMcHU438vWdYlPDQk6WMNHDbQcOggLJa1r1aIEcl7Lu2q1_1kMxNjxe_9AOR2VOAjFP9oE.
 zD.5XBlj9IKw57c0p6IqkvMCAjzqLjoAGZFED1rSv5XBrf76vPs6wF06UdCwBTzJKDQD46Pq.T1F
 ElEwSouO2HD1YWpfIClGYfSCDWiSRV1XlpG6qCYK01pZNMPiPYVoOsWHD1NgXnZvVtzOJpekSXWA
 iRtZzMMKSaq8OqOh.MdgPoLN8u0DA_mTqWguRr6D9r94Wvh39pxYJcUpcKErHdEl4GC.XWR_5frM
 JZz8X_dMVvHzg995Ls8YxVWWnQgun1hkPqmnO1UAE3k8YCT7uwwUXeS19oD1Yhy1xgVL92bOQR6J
 spynAnYliHm2g_xONBOIZqL16lpKOwZ.j8M_RkWakrfeInQJli_qMNA9ZcXgm1ldJ3yVc2Ng73fR
 x2a5AhnTl2pZtXQPDQgyFhxjFySXobjTmV03Q4mlo6JXDZ0qTwG4Jglj_iFoLYqFSmTu2RJHWQux
 9sv9fJuxX1ctWx2frPk9UeZC7Ytp5POWaONE__TmpPLUijUmwXpHgSfLnJvFLlWRnkkJLFWrwOza
 i1P7ygCopTAdrgWdfAok0yzYU.LqgBzjJMm1k.PNE40M_Jc_AgM9f7yyIV6A6nCKxcfKPxwvFBfX
 Y8p_MN4HvIn2IsZrw1FcqWabdc5zENumRBBrOpUnoHAC3BNAXcYBFGL_P7ezJVgiky1K78fi1.ho
 4t43SHYunHG_qR_ip_.6M6NDcW9RlMnqNgZYn40qqqnVAxXMLpBJ5dCRbJF3ZUOjkjhgHb_A.gT7
 gqv5SJhgjakH2EyUsY3DhLtnxkLntGVzWYJr0kSI2oW4VkRco0GRrvdjC5FhN_nDCrY18a.YZdz6
 YhMSgeJ5iK6Ib_FhcZh.hWAHg7L01mNVo37SOnBME1.0YRgWk47stUCuDIAHqiwe5SxlQ4zmgNW2
 Hm3yIylqUqp9j8YjJLRn7kkkupPMjB_TBpSc636Z6lZM5tKABkohggcO4.BWS3WnkzFqQKmW5CjA
 zQEDX70yZya7LS9FVyy2dx_bZu56CA_GlgGDYICstRl5swTB3cJUtlxqyFmGQXWQfuPKSP1GwC.h
 j_tmPgSsMMoqj2kr7dwbQlg--
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic302.consmr.mail.ne1.yahoo.com with HTTP; Fri, 26 Aug 2022 19:04:22 +0000
Received: by hermes--production-ne1-6649c47445-zmkqs (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 0f833e2dbebcb0f01cf2b23fd6dfff04;
          Fri, 26 Aug 2022 19:04:20 +0000 (UTC)
Message-ID: <537daae0-606c-3db4-59dc-2165cc4d212c@schaufler-ca.com>
Date:   Fri, 26 Aug 2022 12:04:19 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH] Smack: Provide read control for io_uring_cmd
Content-Language: en-US
To:     Paul Moore <paul@paul-moore.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Ankit Kumar <ankit.kumar@samsung.com>,
        io-uring@vger.kernel.org, joshi.k@samsung.com,
        casey@schaufler-ca.com
References: <CGME20220719135821epcas5p1b071b0162cc3e1eb803ca687989f106d@epcas5p1.samsung.com>
 <20220719135234.14039-1-ankit.kumar@samsung.com>
 <116e04c2-3c45-48af-65f2-87fce6826683@schaufler-ca.com>
 <fc1e774f-8e7f-469c-df1a-e1ababbd5d64@kernel.dk>
 <CAHC9VhSBqWFBJrAdKVF5f3WR6gKwPq-+gtFR3=VkQ8M4iiNRwQ@mail.gmail.com>
 <83a121d5-a2ec-197b-708c-9ea2f9d0bd6a@schaufler-ca.com>
 <CAHC9VhQStPdfWwTKwqfz67hr3PErHmdu+s_3mAfATb0mu7MD2w@mail.gmail.com>
 <2e6b56cf-d04b-6537-62f4-a4cb0191172a@kernel.dk>
 <CAHC9VhQ2gVEuHe_mhkv7=Ju8co1L+aQ7=WAR_CpmJ7wS8=0+0g@mail.gmail.com>
 <beeb2f29-287c-0191-b03c-8f7a2a6c5f86@schaufler-ca.com>
 <CAHC9VhS15JEJvV8Pp=bAGj5HpVsLiRRHpRt1yi1h-W0GSQgjKg@mail.gmail.com>
From:   Casey Schaufler <casey@schaufler-ca.com>
In-Reply-To: <CAHC9VhS15JEJvV8Pp=bAGj5HpVsLiRRHpRt1yi1h-W0GSQgjKg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Mailer: WebService/1.1.20595 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/26/2022 11:59 AM, Paul Moore wrote:
> On Fri, Aug 26, 2022 at 12:53 PM Casey Schaufler <casey@schaufler-ca.com> wrote:
>> On 8/26/2022 8:15 AM, Paul Moore wrote:
>>> On Tue, Aug 23, 2022 at 8:07 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>> On 8/23/22 6:05 PM, Paul Moore wrote:
>>>>> On Tue, Aug 23, 2022 at 7:46 PM Casey Schaufler <casey@schaufler-ca.com> wrote:
>>>>>> Limit io_uring "cmd" options to files for which the caller has
>>>>>> Smack read access. There may be cases where the cmd option may
>>>>>> be closer to a write access than a read, but there is no way
>>>>>> to make that determination.
>>>>>>
>>>>>> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
>>>>>> --
>>>>>>  security/smack/smack_lsm.c | 32 ++++++++++++++++++++++++++++++++
>>>>>>  1 file changed, 32 insertions(+)
>>>>>>
>>>>>> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
>>>>>> index 001831458fa2..bffccdc494cb 100644
>>>>>> --- a/security/smack/smack_lsm.c
>>>>>> +++ b/security/smack/smack_lsm.c
>>>>> ...
>>>>>
>>>>>> @@ -4732,6 +4733,36 @@ static int smack_uring_sqpoll(void)
>>>>>>         return -EPERM;
>>>>>>  }
>>>>>>
>>>>>> +/**
>>>>>> + * smack_uring_cmd - check on file operations for io_uring
>>>>>> + * @ioucmd: the command in question
>>>>>> + *
>>>>>> + * Make a best guess about whether a io_uring "command" should
>>>>>> + * be allowed. Use the same logic used for determining if the
>>>>>> + * file could be opened for read in the absence of better criteria.
>>>>>> + */
>>>>>> +static int smack_uring_cmd(struct io_uring_cmd *ioucmd)
>>>>>> +{
>>>>>> +       struct file *file = ioucmd->file;
>>>>>> +       struct smk_audit_info ad;
>>>>>> +       struct task_smack *tsp;
>>>>>> +       struct inode *inode;
>>>>>> +       int rc;
>>>>>> +
>>>>>> +       if (!file)
>>>>>> +               return -EINVAL;
>>>>> Perhaps this is a better question for Jens, but ioucmd->file is always
>>>>> going to be valid when the LSM hook is called, yes?
>>>> file will always be valid for uring commands, as they are marked as
>>>> requiring a file. If no valid fd is given for it, it would've been
>>>> errored early on, before reaching f_op->uring_cmd().
>>> Hey Casey, where do things stand with this patch?  To be specific, did
>>> you want me to include this in the lsm/stable-6.0 PR for Linus or are
>>> you planning to send it separately?  If you want me to send it up, are
>>> you planning another revision?
>>>
>>> There is no right or wrong answer here as far as I'm concerned, I'm
>>> just trying to make sure we are all on the same page.
>> I think the whole LSM fix for io_uring looks better the more complete
>> it is. I don't see the Smack check changing until such time as there's
>> better information available to make decisions upon. If you send it along
>> with the rest of the patch set I think we'll have done our best.
> Okay, will do.  Would you like me to tag the patch with the 'Fixes:'
> and stable tags, similar to the LSM and SELinux patches?

Yes, I think that's best.

