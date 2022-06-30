Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 540A4561E1E
	for <lists+io-uring@lfdr.de>; Thu, 30 Jun 2022 16:37:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237189AbiF3OhL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jun 2022 10:37:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237097AbiF3Ogz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jun 2022 10:36:55 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3A3F19290
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 07:32:04 -0700 (PDT)
Received: from [192.168.88.254] (unknown [180.245.197.13])
        by gnuweeb.org (Postfix) with ESMTPSA id BAF36800C2;
        Thu, 30 Jun 2022 14:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1656599524;
        bh=L8y1g3VL3G5xx9Z5l17ACVRT2qjYe2FaSZfh3gQ6cHQ=;
        h=Date:To:References:Cc:From:Subject:In-Reply-To:From;
        b=EtNQoBqmuUHLHyLe5vkX5Fd+pN/ZQx3hdkaSv9Tb40mka9+CQbD9vNohaiahL6p/Z
         EsgUAKXj1BBcBkeyMRf9IJAf+1QeYwHtMJhTM5UV28+oqZVWtGQnQh4BDwc/P/35La
         coEstEGs+TJtsrIBQ8AvxgFFLmsCALz4Ee39c7atN31uLBJv1F7HPY/emd01zImyuH
         gBa8/p3ZGkoGa94WUhPAXAxxc5VcNGl52oXBft1hXs3tskUCehron8EgrlzCFM5yUh
         s8Mk91RIbY9B4ojeKSk1xXDnD0RCV8BwL2AB/8lINw5othhweB2J3+S8+l8Sa4y96j
         Or/S1/4y/pNOw==
Message-ID: <a72fcfe9-cc9e-9ca0-9fc7-d97fe44d4599@gnuweeb.org>
Date:   Thu, 30 Jun 2022 21:31:49 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>
References: <cover.1656580293.git.asml.silence@gmail.com>
 <decaf87bd125ad0e77261985e521926aff66ff34.1656580293.git.asml.silence@gmail.com>
 <30f95627-eb6c-c743-8fb2-11b0b874e00b@kernel.dk>
 <af745cb5-908c-1532-e5ea-a875a5166ec7@gmail.com>
Cc:     Eli Schwartz <eschwartz93@gmail.com>, Jens Axboe <axboe@kernel.dk>,
        io-uring Mailing List <io-uring@vger.kernel.org>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
Subject: Re: [PATCH for-next 3/3] test range file alloc
In-Reply-To: <af745cb5-908c-1532-e5ea-a875a5166ec7@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/30/22 9:19 PM, Pavel Begunkov wrote:
> On 6/30/22 14:09, Jens Axboe wrote:
>> On 6/30/22 3:13 AM, Pavel Begunkov wrote:
>>> @@ -949,5 +1114,11 @@ int main(int argc, char *argv[])
>>>           return ret;
>>>       }
>>> +    ret = test_file_alloc_ranges();
>>> +    if (ret) {
>>> +        printf("test_partial_register_fail failed\n");
>>> +        return ret;
>>> +    }
>>
>> If you're returning this directly, test_file_alloc_ranges() should use
>> the proper T_EXIT_foo return codes.
> 
> Nobody cared enough to "fix" all tests to use those new codes, most
> of the cases just return what they've got, but whatever. Same with
> stdout vs stderr.

That error code rule was invented since commit:

    68103b731c34a9f83c181cb33eb424f46f3dcb94 ("Merge branch 'exitcode-protocol' of ....")

    Ref: https://github.com/axboe/liburing/pull/621/files

Thanks to Eli who did it. Eli also fixed all tests. Maybe some are still
missing, but if we find it, better to fix it.

-- 
Ammar Faizi
