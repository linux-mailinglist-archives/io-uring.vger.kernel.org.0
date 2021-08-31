Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 001663FCA7A
	for <lists+io-uring@lfdr.de>; Tue, 31 Aug 2021 17:03:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230237AbhHaPEO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 31 Aug 2021 11:04:14 -0400
Received: from sonic317-38.consmr.mail.ne1.yahoo.com ([66.163.184.49]:41461
        "EHLO sonic317-38.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236497AbhHaPEH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 31 Aug 2021 11:04:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1630422191; bh=LOTPqNyspbrqM9nxQcJrAcyZI7sQjXW1mZnX0fr5PN0=; h=Subject:To:Cc:References:From:Date:In-Reply-To:From:Subject:Reply-To; b=GL/3hElvuTn6ZU0RSJbyptMxjI/O604DD4XkJC093dLutxhdTEqRDnwn6sb8x+aO14qsyQ6qgVhVAHegebwkwAAkQTj1BTMzYjEvTu7TzUFDYO5dFDo0dL1G/f7BKJiNvRRQugz8451PaAgW82AbGYXhWXKzGCKlf7vZnqgyCnqkRQA+lDIaOoNhG/vB1K5iPsCIsatsrdMSoqH2GEui42tylGS6wIG7/N+YbDCl4ZzAqS53Gsj9JjEMyJO96VIZHuHdzvD2kKw+AiIQkmYkt9TVyfds3iFjKz9J+eCwpDBga1Q9tzfry9woe9yuGSDrwQTlVgwjwlI9cpTgme/zYA==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1630422191; bh=NOHLz6kK6UgdnKHnssrO1Ti4n/aKd17oBJxmiDCAKiG=; h=X-Sonic-MF:Subject:To:From:Date:From:Subject; b=eydMWzo6TvA0sMgucOyuYhdgskqR1MdwDXQXF7o0KyS/IMU7BxfBworTi/eZbObq/31fwq4eG2MsTgw7X7OvSkq5URtpZgBnjqCIJmU9JwIlIoIOel0N5b9mZJOSUoYiLOjt/NKjEIsLgk/2Hp/bfjGhbnLoYX4t4Gs3LGqGLC8GJVOJgJNmMuHe2tMwA6V0/BgNWDAUnoQ+2TdL6kYdhfo2rKXwMsrmkUTwPxlmnnOo1UDsDQ81D4iD0QVwzYwTpNakLx32y2XZs2eQlvBz7y6OkMW9LtudHE+guoFk2vtj0+1ljWMR8H67C7uMVDk/HKP/+7anEFkpUnE7RLTC8Q==
X-YMail-OSG: D4cFvJkVM1lCYdIuptPnfoEsF9C0Ba2yx3eX_x0IgHmYxqeiiC28m9ipJV4mumS
 iMqVasLkn_HDL2JHMGiXSRU8bXUKDVr2b2H6RIV.VwSLX72p7QITyeWH4qIQIQufQLw4156jZMKG
 XYY17Vw8kkITnJzvemVHMPpJJresQnTMhXdbhrlZek5FhqAoklCCCYzg56VhyfrOgM0uSikbI4K8
 5VjVRf.pldPAXcOJul9v1i5GA4DVvB.dd6hP_B59wvJkyjlV0E2ntrrYwaQ.RKbFkEOUl.wJsE8a
 dbvS4aodmE7d.4b3WB65da6yd4wMJnjv2EBf3KYhYB_dij9lg3sraqH.x.297N41p8ZW7X6xgzwd
 EMCsKdAoVQ2KOn7EVTWElElB.0GeR2Wi2chXtaI6H2CDEVw_mNiUqcQrcn965ZaGT0qnsPjnbvg9
 KbvJ7mb9Pk4_Bj.NYctZ7os_6k13SlRUaKd3gYHckIwiiSnuGgfRfopEYYzUHj50hPcDP0F1FB.u
 jZLux7AGoOLQzJMiO1qOWAEGKSinChasHbxfA2IPZF6vaPbd7sIw4WEG71uc6.yRsUUPE1qdjNcD
 wf.NPWzKgzP44i8k6J2vxFTHdbjRtwWNgUOIr7X7spRfiZamJYUIBitrcB8kQu2PwW6a7Rdlbkf_
 8DS3l.ROJH3YZs1DlJ5FORkXtGXw3pCPvujehXLE2jffLL2b_X4xdrQMswRXeFebPnbG9dQhyirA
 sgDttcfex63oxk08pMqniq5nwTwCSYX7WUINmishygtcIHJt7NpCGOkShXt12n8dN.ei9Mto6UPP
 77AT0JKHGPPEXk1elZGTpxLqeOgrnoYt_q7gFDdboxPz1.OJpnbVrhkGJsrfGWRkpuqM0LuGGP2P
 6OZ8o3.pIcyz7MGS9xlO7bUVa9Jycz7ChhIJQtC5PRiQwT7fW2NpVwPYGFuWaG74UZONkS1HXktV
 qcH_h9PxXv6GiYxloPJLP0mu0kVGIyPsCZIFGSqwImNGY.B8m.xdk._13ESf0kWEVohQpWvxEWuo
 kzxrEB6gx1O.yMH8RxlD6yIYu4ziBCHoIVA1l4Zvj39JqpC8VYmXk0k.u_H0f0ovpQymfTuz8Qyj
 gFCkAm78p20c_VkQwVrhL3u6WA04i8a3sl1dy3HyCwVOq1by.qW6AWUDopxsUO2taCM9Ub3CjGpe
 z9kHUY6X920xE2eHd0dI29Q2yPUuwD5lMnB7HPl8hIufED7WoRW2.QAj99HnS883o5I2AGcBcfEe
 KH5CoosFoTu329hdehWESBU.CpWoij_WD2j2Q.h.hNNERNXDdNLJ0QTYyCaFlJGfWnTD9TsnZVA2
 gCwbBnZtrlRmGDlwTvPvXbMtRgCLe1RUkmS8Z.iouxVWU2JKvEhaO51ngPo2UIYabxJNXrEpiocI
 qCVWETjwBuBREKzB4yYfCQBXCp09_NA1i5W4jvVpUfIQ4EX3ifRh8N1TGd2HCc9ku_p9OTdKo1n9
 tdj7VCHA673nUynAX5YKZn7.HyTXMEe0Zzllj1nUFR6Q6GFvEN3KKHMmJ_fyKtWRItwroS8awBg7
 x3j7lT8DO_Pt0ko_ug9WHcX9EXMJ8RExiTK9TCDuhyc1rR3F52xlvG3w3RaKjELMOzFCrqzZna7V
 7hCXOJ6qDM3xl8ycCF2RNc0IYqfzn5m81cg9FUPbHx2nzGXCmKJzCjxFzmTXs95m4oaTOkvzXq5O
 Vb8mPQI_t3xCEZSHIjsqaBywm_n0xHGiZHlL84YDdGXdD8_KJtXEspy2jDqoSk120iDosS8nJMq9
 EXZYeTzrA9w2EG9XTQcudO7F2DkX.16Stiv4qk52aVE7AGo3o582GiUprUuzRWHXjmUIteeMpydN
 pK73HcTwCnb9gB96AgvA9cQZT03TU90Xr8nTtK7KClUCkwkpjNMD0sPxbcCnSOhdM1TIt3vQQQqJ
 HDC2.CKgZLQ6F53XOKB8R3WYCzfFzC63GlscRu78ygST_P7Kwzb4fHW0x992gF3igK2QS6LxPWwQ
 rmVLHzjaVtdTwgLmNz9bgUyM1WnogL5LuB6nqUPMIeP2A5gpxKMwp6cvQctfXOu75QgDCCf63iH8
 iOHL4i7Adcdl38mlb98ifuTxPNq4OcgeTKqkSWtln1h35XgbpG_U4fGr8.Dgfk94CDmTVdYQLt45
 wiK46ZdLZ2WHXbqAa4MI9WVoj5dRf2yVDWhfyaAXgmcxjapo6tzEuLksXhn3izCdACB5AOkBABQL
 TRBn1jDU3.DnIV10vhCRNa.KOlcWwyPBNRJv6CHgTVbafOqWcRWDny.rXpAnW2RedQ1wr2OyvCi6
 jh2bV3CkUedTChCjfrBeCehjPeabGPC1b4O6FAx3yulf6J79gRr4ixAQb
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic317.consmr.mail.ne1.yahoo.com with HTTP; Tue, 31 Aug 2021 15:03:11 +0000
Received: by kubenode531.mail-prod1.omega.gq1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID edde45835be1392ba24d927ad035bea1;
          Tue, 31 Aug 2021 15:03:09 +0000 (UTC)
Subject: Re: [RFC PATCH v2 9/9] Smack: Brutalist io_uring support with debug
To:     Paul Moore <paul@paul-moore.com>
Cc:     linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-audit@redhat.com, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Casey Schaufler <casey@schaufler-ca.com>
References: <162871480969.63873.9434591871437326374.stgit@olly>
 <162871494794.63873.18299137802334845525.stgit@olly>
 <CAHC9VhSPW0R=AQGCaz9HNO5mXmCtscto-7O=9Af9B_EuCa5W=A@mail.gmail.com>
From:   Casey Schaufler <casey@schaufler-ca.com>
Message-ID: <50ff8adf-d99c-e9a9-3d8b-cb9c2777455f@schaufler-ca.com>
Date:   Tue, 31 Aug 2021 08:03:07 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <CAHC9VhSPW0R=AQGCaz9HNO5mXmCtscto-7O=9Af9B_EuCa5W=A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Mailer: WebService/1.1.18924 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/31/2021 7:44 AM, Paul Moore wrote:
> On Wed, Aug 11, 2021 at 4:49 PM Paul Moore <paul@paul-moore.com> wrote:
>> From: Casey Schaufler <casey@schaufler-ca.com>
>>
>> Add Smack privilege checks for io_uring. Use CAP_MAC_OVERRIDE
>> for the override_creds case and CAP_MAC_ADMIN for creating a
>> polling thread. These choices are based on conjecture regarding
>> the intent of the surrounding code.
>>
>> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
>> [PM: make the smack_uring_* funcs static]
>> Signed-off-by: Paul Moore <paul@paul-moore.com>
>>
>> ---
>> v2:
>> - made the smack_uring_* funcs static
>> v1:
>> - initial draft
>> ---
>>  security/smack/smack_lsm.c |   64 ++++++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 64 insertions(+)
>>
>> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
>> index 223a6da0e6dc..7fb094098f38 100644
>> --- a/security/smack/smack_lsm.c
>> +++ b/security/smack/smack_lsm.c
>> @@ -4691,6 +4691,66 @@ static int smack_dentry_create_files_as(struct dentry *dentry, int mode,
>>         return 0;
>>  }
>>
>> +#ifdef CONFIG_IO_URING
>> +/**
>> + * smack_uring_override_creds - Is io_uring cred override allowed?
>> + * @new: the target creds
>> + *
>> + * Check to see if the current task is allowed to override it's credentials
>> + * to service an io_uring operation.
>> + */
>> +static int smack_uring_override_creds(const struct cred *new)
>> +{
>> +       struct task_smack *tsp = smack_cred(current_cred());
>> +       struct task_smack *nsp = smack_cred(new);
>> +
>> +#if 1
>> +       if (tsp->smk_task == nsp->smk_task)
>> +               pr_info("%s: Smack matches %s\n", __func__,
>> +                       tsp->smk_task->smk_known);
>> +       else
>> +               pr_info("%s: Smack override check %s to %s\n", __func__,
>> +                       tsp->smk_task->smk_known, nsp->smk_task->smk_known);
>> +#endif
> Casey, with the idea of posting a v3 towards the end of the merge
> window next week, without the RFC tag and with the intention of
> merging it into -next during the first/second week of the -rcX phase,
> do you have any objections to me removing the debug code (#if 1 ...
> #endif) from your patch?  Did you have any other changes?

I have no other changes. And yes, the debug code should be stripped.
Thank you.

>
>
> --
> paul moore
> www.paul-moore.com
