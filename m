Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 806F075E190
	for <lists+io-uring@lfdr.de>; Sun, 23 Jul 2023 13:05:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbjGWLFf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 23 Jul 2023 07:05:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbjGWLFe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 23 Jul 2023 07:05:34 -0400
X-Greylist: delayed 581 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 23 Jul 2023 04:05:31 PDT
Received: from s1.sapience.com (s1.sapience.com [72.84.236.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2504D10D1;
        Sun, 23 Jul 2023 04:05:31 -0700 (PDT)
Authentication-Results: dkim-srvy7; dkim=pass (Good ed25519-sha256 
   signature) header.d=sapience.com header.i=@sapience.com 
   header.a=ed25519-sha256; dkim=pass (Good 2048 bit rsa-sha256 signature) 
   header.d=sapience.com header.i=@sapience.com header.a=rsa-sha256
Received: from srv8.prv.sapience.com (srv8.prv.sapience.com [x.x.x.x])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (secp384r1) server-digest SHA384)
        (No client certificate requested)
        by s1.sapience.com (Postfix) with ESMTPS id 897AF480A2C;
        Sun, 23 Jul 2023 06:55:49 -0400 (EDT)
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=sapience.com;
 i=@sapience.com; q=dns/txt; s=dk-ed25519-220413; t=1690109749;
 h=message-id : date : mime-version : subject : to : cc : references :
 from : in-reply-to : content-type : content-transfer-encoding : from;
 bh=lr/rmxq8EwVEr8RixWBy+Sg5CImzrHwG+MAvhFEdjrY=;
 b=5xq7ImbbNDtqxgLyR74YtRbUPMj7JgZq6+4t+9YxzN6WyMRoiV2aWM0RWau4syANOCqra
 T05v5YPcYK35M/GDQ==
ARC-Seal: i=1; a=rsa-sha256; d=sapience.com; s=arc6-rsa-220412; t=1690109749;
        cv=none; b=InRQ2iCFm9Ckw6g7VGsf+8b6tDblLqbx9m33kc3oxcxf4nRgoFrPw07j0THgoUNZYpqfsAjMG6PdgBMjKh9B4lOV4pxi326W+SFCoRpY+nJgl82VBxZebQu/+jLRePEVz01jTVoHx11LXMFO8IUPypSdTFMfwZariA0iDtl10DgQHu23ooLUConcRoITayOlXyChmnQtuHcTGuqDWz3H2PwBC5ipQsN+QrD7j/zZuDL+snhJ99Rbhr6Iu7/dlSVh3CVYtJAXDFIIzHdTEC48V0zbxRPVM+lqlNdxItCn4PMwhTicYE01LqQc7m+dPsgCbCqFDRu5BBaBZi+I3Uou+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; d=sapience.com; s=arc6-rsa-220412;
        t=1690109749; c=relaxed/simple;
        bh=GLmMY0POgZIVkTblze2QbmkCf2EJW164BJIcQRZnmc8=;
        h=DKIM-Signature:DKIM-Signature:Message-ID:Date:MIME-Version:
         User-Agent:Subject:To:Cc:References:Content-Language:From:
         In-Reply-To:Content-Type:Content-Transfer-Encoding; b=BBn2gTVC3/aM1tWPCpEsYQIOU5/I3myjX+roKKs39ISfPXmDwpHg03NsoPjNiJ63xvavbuv/rvGPU56C/SO3D1BZ7snc1ptl4BGylIiHaW48gXcoQx+GGljjJ40NjDr+LL4k5PPs0QcSjDtnvEnk9zOFl6k61xnvBPtYMi8ZVpSnW/H9YgRwUYH9dE3E2joQvTGmXHKcWyRSI0eACyjK1GDcKCj4g8SLZhcCCAWLWuPAVN5KAgW/TVGjhWt3PiS2QFHlGVI2CUElt2wCApzVwrT4nhYQqLuy4cq77V35CXtoDCrWszEFSKE94/7IYCzjVscXmInWYB39CPZ71GH/Rg==
ARC-Authentication-Results: i=1; arc-srv8.sapience.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sapience.com;
 i=@sapience.com; q=dns/txt; s=dk-rsa-220413; t=1690109749;
 h=message-id : date : mime-version : subject : to : cc : references :
 from : in-reply-to : content-type : content-transfer-encoding : from;
 bh=lr/rmxq8EwVEr8RixWBy+Sg5CImzrHwG+MAvhFEdjrY=;
 b=SVpSLp5s5ZSniJoLH1bOMkeWMuAULB1/RmtfCIDsU8gWVlY3b2LTZNX7eoMSkKCQaGoQU
 YjYGAPaUHReZJecXPpJI2oq5RLvDW/6UUwIitjtSiGReOjUXCkzy4O0Fi1rbkLIk3PVTni4
 jyRn7WQIaaVvxU2JzZInuj8fi1vMfJynK3wZG/ywFPfTdZu7EaGiv1He76Cx/MpGlJsy7bj
 xB31hQuxPkwzDoj7F+xPRMlwZhS3e+JXzEhH8QaGsAiW07krkrsZJxsX28omVzIambUgbaC
 veFDKheLm01sBYZEh0xG1u8lhUZ+j1gB8aZKK8KsJ9UarBX8NK3QS3kLFJ5A==
Message-ID: <e7e4cf5c-c09d-7747-b466-cef6673f2f10@sapience.com>
Date:   Sun, 23 Jul 2023 06:55:49 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.4 800/800] io_uring: Use io_schedule* in cqring wait
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Oleksandr Natalenko <oleksandr@natalenko.name>
Cc:     stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andres Freund <andres@anarazel.de>,
        Jens Axboe <axboe@kernel.dk>
References: <20230716194949.099592437@linuxfoundation.org>
 <20230716195007.731909670@linuxfoundation.org>
 <12251678.O9o76ZdvQC@natalenko.name>
 <2023072310-superman-frosted-7321@gregkh>
Content-Language: en-US
From:   Genes Lists <lists@sapience.com>
In-Reply-To: <2023072310-superman-frosted-7321@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/23/23 06:50, Greg Kroah-Hartman wrote:
> On Sun, Jul 23, 2023 at 11:39:42AM +0200, Oleksandr Natalenko wrote:
>> Hello.
>>
>> On neděle 16. července 2023 21:50:53 CEST Greg Kroah-Hartman wrote:
>>> From: Andres Freund <andres@anarazel.de>
>>>
>>> commit 8a796565cec3601071cbbd27d6304e202019d014 upstream.
>>>
>>> I observed poor performance of io_uring compared to synchronous IO. That
...
>>
>> Reportedly, this caused a regression as reported in [1] [2] [3]. Not only v6.4.4 is affected, v6.1.39 is affected too.
>>
>> Reverting this commit fixes the issue.
>>
>> Please check.
> 
> Is this also an issue in 6.5-rc2?
> 
> thanks,
> 
> greg k-h

Yes - I can confirm this issue is in 6.5-rc2 and with Linus' commit 
c2782531397f5cb19ca3f8f9c17727f1cdf5bee8.


gene

