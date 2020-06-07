Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 740581F0C59
	for <lists+io-uring@lfdr.de>; Sun,  7 Jun 2020 17:02:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728045AbgFGPCE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 7 Jun 2020 11:02:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726717AbgFGPCD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 7 Jun 2020 11:02:03 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8B65C08C5C3
        for <io-uring@vger.kernel.org>; Sun,  7 Jun 2020 08:02:03 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id b201so7380043pfb.0
        for <io-uring@vger.kernel.org>; Sun, 07 Jun 2020 08:02:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vj3N+mNfEnwtqPocxwGKVfYWZt9LYBUBTl7ZHih5Als=;
        b=ksk/pExOmM8Utak8adllATuRTMi1/DGEj9Hr/M1KbrKpEcx840+9oeZof+/C+GkBhb
         Tcci1LCXjRJmp7xhHK/Jz+zOybbtmMVHvS8AmmFStHC9G36nNzLKh6gUGlPRgT8RzFLE
         Dfn/s76K2rD1cWIfDWHf04u690pOAP7rKkDegak0b+JWLUa2CkqHpVvvBma/w0F1HgUf
         BPmAswgter0nJfETgEXB3SGNddCVZOcfp8Znxq4loNaKGLA6tWHNOgCgForpHqjP2a/r
         9Zq5DiMQA4ExUpg+NuIKDyrGd3FusgaCnoTWoeh8J9RrMh0obTq0B81HEYxCtA62n1xk
         tOfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vj3N+mNfEnwtqPocxwGKVfYWZt9LYBUBTl7ZHih5Als=;
        b=Oa5uqIlRMJeZ7Tx/Sakpf76WsOC1gqEWTK+4RnEPzZk6WwyyzzFPAtDKuTpK/AiNyk
         ZzRR6QVBiIus5sBRgUJAlg4oiyVzpQXRwtn/w/31yx8oFcfwavT3gP9bRoewK+4bp9DE
         Bfo6pM0akdmRD58yuM4uRzcn1gW3MsQmI9QZE0uddN1fprEBDOe2/4Aoq0CoI1hYMUM6
         6IlfKPhxHht91WCiprkei6l9CkV71UXNpokfltG9nazsTD7W7wsujbI1hcmJ2buvpikw
         JEXO82xgUfWiKx0cFp8odfPGi0U11MNe3wdUDW1NLdUMdIbxj4HSUYAFi2w0SWs4hTob
         3M+w==
X-Gm-Message-State: AOAM532TQj/KuCy6SvUhNoO9oIvO0oisWECmb9TWBiraBBIaVPBPMz7l
        W1Ph3vtNHmTEwISS+sLDl3LhM0EWNAqCZQ==
X-Google-Smtp-Source: ABdhPJw1I/lZs1yC5MH6+f03t/1yXqRdP9pn1RMoWppElnNADKXqv8yom8FQglh1p5PStewVLljuIA==
X-Received: by 2002:a62:25c3:: with SMTP id l186mr16292746pfl.154.1591542123322;
        Sun, 07 Jun 2020 08:02:03 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id g18sm3842255pgn.47.2020.06.07.08.02.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 Jun 2020 08:02:02 -0700 (PDT)
Subject: Re: [PATCH v5 2/2] io_uring: avoid unnecessary io_wq_work copy for
 fast poll feature
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <a2184644-34b6-88a2-b022-e8f5e7def071@gmail.com>
 <20200601045626.9291-1-xiaoguang.wang@linux.alibaba.com>
 <20200601045626.9291-2-xiaoguang.wang@linux.alibaba.com>
 <f7c648e7-f154-f4eb-586f-841f08b845fd@linux.alibaba.com>
 <8accdc46-53c9-cf89-1e61-51e7c269411c@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <9f540577-0c13-fa4b-43c1-3c4d7cddcb8c@kernel.dk>
Date:   Sun, 7 Jun 2020 09:02:00 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <8accdc46-53c9-cf89-1e61-51e7c269411c@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/3/20 7:46 AM, Pavel Begunkov wrote:
> On 02/06/2020 04:16, Xiaoguang Wang wrote:
>> hi Jens, Pavel,
>>
>> Will you have a look at this V5 version? Or we hold on this patchset, and
>> do the refactoring work related io_wq_work firstly.
> 
> It's entirely up to Jens, but frankly, I think it'll bring more bugs than
> merits in the current state of things.

Well, I'd really like to reduce the overhead where we can, particularly
when the overhead just exists to cater to the slow path.

Planning on taking the next week off and not do too much, but I'll see
if I can get some testing in with the current patches.

-- 
Jens Axboe

