Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F5B8350479
	for <lists+io-uring@lfdr.de>; Wed, 31 Mar 2021 18:29:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233911AbhCaQ2g (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 31 Mar 2021 12:28:36 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:45098 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232319AbhCaQ2M (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 31 Mar 2021 12:28:12 -0400
Received: from in02.mta.xmission.com ([166.70.13.52])
        by out03.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1lRdhS-00HJ5m-1Q; Wed, 31 Mar 2021 10:28:10 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=fess.xmission.com)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1lRdhP-005qdR-K5; Wed, 31 Mar 2021 10:28:08 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Dmitry Kadashev <dkadashev@gmail.com>,
        Jens Axboe <axboe@kernel.dk>,
        io-uring <io-uring@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org
References: <20201116044529.1028783-1-dkadashev@gmail.com>
        <20201116044529.1028783-2-dkadashev@gmail.com>
        <027e8488-2654-12cd-d525-37f249954b4d@kernel.dk>
        <20210126225504.GM740243@zeniv-ca>
        <CAOKbgA4fTyiU4Xi7zqELT+WeU79S07JF4krhNv3Nq_DS61xa-A@mail.gmail.com>
        <20210201150042.GQ740243@zeniv-ca> <20210201152947.GR740243@zeniv-ca>
Date:   Wed, 31 Mar 2021 11:28:04 -0500
In-Reply-To: <20210201152947.GR740243@zeniv-ca> (Al Viro's message of "Mon, 1
        Feb 2021 15:29:47 +0000")
Message-ID: <m1ft0bqodn.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1lRdhP-005qdR-K5;;;mid=<m1ft0bqodn.fsf@fess.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18axJtBcCUniFz8RzQG8ulDljcYSflJCpE=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa02.xmission.com
X-Spam-Level: *
X-Spam-Status: No, score=1.3 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG,T_TooManySym_01,
        T_TooManySym_02,T_TooManySym_03,XMNoVowels autolearn=disabled
        version=3.4.2
X-Spam-Virus: No
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4915]
        *  1.5 XMNoVowels Alpha-numberic number with no vowels
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
        *  0.0 T_TooManySym_01 4+ unique symbols in subject
        *  0.0 T_TooManySym_02 5+ unique symbols in subject
        *  0.0 T_TooManySym_03 6+ unique symbols in subject
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Al Viro <viro@zeniv.linux.org.uk>
X-Spam-Relay-Country: 
X-Spam-Timing: total 1023 ms - load_scoreonly_sql: 0.03 (0.0%),
        signal_user_changed: 3.7 (0.4%), b_tie_ro: 2.6 (0.3%), parse: 0.63
        (0.1%), extract_message_metadata: 8 (0.8%), get_uri_detail_list: 0.58
        (0.1%), tests_pri_-1000: 3.7 (0.4%), tests_pri_-950: 1.08 (0.1%),
        tests_pri_-900: 0.81 (0.1%), tests_pri_-90: 46 (4.5%), check_bayes: 45
        (4.4%), b_tokenize: 3.4 (0.3%), b_tok_get_all: 4.7 (0.5%),
        b_comp_prob: 1.16 (0.1%), b_tok_touch_all: 33 (3.2%), b_finish: 0.61
        (0.1%), tests_pri_0: 138 (13.5%), check_dkim_signature: 0.36 (0.0%),
        check_dkim_adsp: 2.2 (0.2%), poll_dns_idle: 807 (78.9%), tests_pri_10:
        1.67 (0.2%), tests_pri_500: 818 (79.9%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH 1/2] fs: make do_mkdirat() take struct filename
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Al Viro <viro@zeniv.linux.org.uk> writes:

> On Mon, Feb 01, 2021 at 03:00:42PM +0000, Al Viro wrote:
>
>> The last one is the easiest to answer - we want to keep the imported strings
>> around for audit.  It's not so much a proper refcounting as it is "we might
>> want freeing delayed" implemented as refcount.
>
> BTW, regarding io_uring + audit interactions - just how is that supposed to
> work if you offload any work that might lead to audit records (on permission
> checks, etc.) to helper threads?

For people looking into these details.  Things have gotten much better
recently.

The big change is that io_uring helper threads are now proper
threads of the process that is using io_uring.  The io_uring helper
threads just happen to never execute any userspace code.

Eric


