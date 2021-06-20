Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F86B3AE0DD
	for <lists+io-uring@lfdr.de>; Mon, 21 Jun 2021 00:17:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbhFTWTZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 20 Jun 2021 18:19:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229708AbhFTWTZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 20 Jun 2021 18:19:25 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 190EEC061574;
        Sun, 20 Jun 2021 15:17:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:
        Subject:Sender:Reply-To:Cc:Content-ID:Content-Description;
        bh=PxeyDOaC5gOG9k7sFphHJqiDSQ/o/65kXWRJvbDb3GE=; b=K3/nXmL8a42OqCpuwQLk9igqqs
        8SDKEfm9iyBqUqCZTXaqhtCmtrLJewE9ZmATsYaKhXX+t2bwB9nNRhuc84LwB8zleq3XOT/kzCCMI
        WPaYhfh3FxBX0i8CZ3EW66xe7+F3FCWcmE9sKleP0ICL9tB2nVhvHzHudV/5JhKswPUIUCmc0R569
        93IpmHlRpTY4ceMNb9GQz2uLFvzkqzu7keNgLcPO98BQvbL6pVLHiNKlG/q1F6yBWwimyWyieqz+y
        rmZ/t0EGv0KZuPPcsavor6YtzOgP4Hpdvdj6rOFQMu40FwwGZ0fwJ/2gTyfeWh6nlvOZOLeWZpgxu
        kOtFXWVw==;
Received: from [2601:1c0:6280:3f0::aefb]
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lv5kd-001ftT-53; Sun, 20 Jun 2021 22:17:11 +0000
Subject: Re: [PATCH v2] io_uring: reduce latency by reissueing the operation
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Olivier Langlois <olivier@trillion01.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <e4614f9442d971016f47d69fbcba226f758377a8.1624215754.git.olivier@trillion01.com>
 <c5394ace-d003-df18-c816-2592fc40bf08@infradead.org>
 <b0c5175177af0bfd216d45da361e114870f07aad.camel@trillion01.com>
 <4578f817-c920-85f1-91af-923d792fc912@infradead.org>
 <7ad30cb0-3322-6c40-2a1b-27308aa757d8@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <ba6ef23b-364a-fafd-2e02-ff9dd4d89560@infradead.org>
Date:   Sun, 20 Jun 2021 15:17:10 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <7ad30cb0-3322-6c40-2a1b-27308aa757d8@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/20/21 1:08 PM, Pavel Begunkov wrote:
> On 6/20/21 9:01 PM, Randy Dunlap wrote:
>> On 6/20/21 12:28 PM, Olivier Langlois wrote:
>>> On Sun, 2021-06-20 at 12:07 -0700, Randy Dunlap wrote:
>>>> On 6/20/21 12:05 PM, Olivier Langlois wrote:
>>>>> -               return false;
>>>>> +               return ret?IO_ARM_POLL_READY:IO_ARM_POLL_ERR;
>>>>
>>>> Hi,
>>>> Please make that return expression more readable.
>>>>
>>>>
>>> How exactly?
>>>
>>> by adding spaces?
>>> Changing the define names??
>>
>> Adding spaces would be sufficient IMO (like Pavel suggested also).
> 
> Agree. That should be in the code style somewhere
> 

It is.

-- 
~Randy

