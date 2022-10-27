Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26A2F61005A
	for <lists+io-uring@lfdr.de>; Thu, 27 Oct 2022 20:36:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234947AbiJ0SgC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 27 Oct 2022 14:36:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234875AbiJ0SgC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 27 Oct 2022 14:36:02 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CDC3635E1
        for <io-uring@vger.kernel.org>; Thu, 27 Oct 2022 11:36:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:Cc:To:Date:Message-ID;
        bh=DxDDtGFB7sK+AffHSRuyAqBKYu4461qzyO9nxbLScMU=; b=D3ldPyDRbGUd0P6rwfKoeqdOrS
        BO7R4kWi/AApUmdhVJQNfK4kh7n0vo+q9oAr0hFDDJBgC98PBDZg+Padn37/f5TNS52r9vRorhsoi
        ARYBa5JeFhlIPEYp3qTzX8HGGjNUT4WtX2G7dQlf/5C6c0AMHW2wUOKbPCJWxgyCVs23wP/NhKdnq
        PXNaxfr1OsyvOOr5ZCh+xObdgOZ+H5HgAzGeE1mNjozY9KEgLytrXe0lObWRkJYUlRmwlfbDMTyfd
        /RPem1tc2Z8dosd4gs/6Xf5m5vHEYAEUD0cOP+97jUCPB4jKpcXdHrcqxah3G2bVAeiOlSxhT5u7N
        j9kU7JlSG5VVzrklZfjdwBe7uskBqkOtcePvgn80XfCDdIw1fLKeF2WtMI3HVodsJ1KdpItoR8p3l
        yF/A1pisNppEcXl5l0h1yJMXJr+luEKxtDBYspXCaXZdVMb8honjs+T6S022TLbEH+ctSccIiF0xa
        23gx1rSB5nEUiyXvNjiNxTId;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1oo7jT-0064XE-5B; Thu, 27 Oct 2022 18:35:59 +0000
Message-ID: <c21825d5-a342-f204-a9a7-3c1c9a7d626c@samba.org>
Date:   Thu, 27 Oct 2022 20:35:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: Problems replacing epoll with io_uring in tevent
Content-Language: en-US, de-DE
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <c01f72ac-b2f1-0b1c-6757-26769ee071e2@samba.org>
 <949fdb8e-bd12-03dc-05c6-c972f26ec0ec@samba.org>
 <270f3b9a-8fa6-68bf-7c57-277f107167c9@kernel.dk>
 <9b42d083-c4d8-aeb6-8b55-99bdb0765faf@samba.org>
 <fedaf2e7-8a71-2fb2-5d7f-a03c01f824ba@kernel.dk>
From:   Stefan Metzmacher <metze@samba.org>
In-Reply-To: <fedaf2e7-8a71-2fb2-5d7f-a03c01f824ba@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Am 27.10.22 um 14:12 schrieb Jens Axboe:
> On 10/27/22 2:51 AM, Stefan Metzmacher wrote:
>> Hi Jens,
>>
>>> No problem - have you been able to test the current repo in general? I want to
>>> cut a 2.3 release shortly, but since that particular change impacts any kind of
>>> cqe waiting, would be nice to have a bit more confidence in it.
>>
>> Is 2.3 designed to be useful for 6.0 or also 6.1?
> 
> 2.3 should be uptodate as of 6.0, don't want to release a new version
> that has bits from a kernel release that hasn't happened yet. The
> plan is to roughly do a liburing release at the same cadence as the
> kernel releases. Not that they are necessarily linked, but some features
> do obviously happen in lockstep like that.
> 
>> Maybe wait for IORING_SEND_ZC_REPORT_USAGE to arrive?
> 
> That'll be 2.4.

Ok, fine.

metze

