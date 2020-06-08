Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AEAB1F13C2
	for <lists+io-uring@lfdr.de>; Mon,  8 Jun 2020 09:44:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729020AbgFHHoa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 8 Jun 2020 03:44:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726009AbgFHHo3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 8 Jun 2020 03:44:29 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6203C08C5C3
        for <io-uring@vger.kernel.org>; Mon,  8 Jun 2020 00:44:29 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id d15so74276edm.10
        for <io-uring@vger.kernel.org>; Mon, 08 Jun 2020 00:44:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=e1IlhV9HDmMpLpi5OBJ6qZYT4Tk21nQF05pov5oJX6c=;
        b=ZHRAdT1M6iMcBkjkd5yy7Y2WravvgBvtPBuDJKiquGPmk/IiKFKFEYwISLI2WeWtTu
         nX74IMSnN3m+WplGekQXKQXqDuRxfTNS2Uyq/7Oc8K//BdxWOGJAPUMjSyzFIrhb73nJ
         sv0eR43rKebQyToE7nL7Q77BUGk3mb8+g8UVvrsrCP18aqsriEs+IWl58pFxau8O072a
         SLUwRjHVN2EWPImOb4EUzxWPbenZ9TQaAy+50HcIrgnXsbJZnjMoMlUSKMEFlJy7qDmw
         oZ3gp/ohuzJMY0J2LeVs+EBTOCUNkPATAsApSb9WC03cJdFSlh8HBNlx8ZVweFCpQ/Eg
         FvIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=e1IlhV9HDmMpLpi5OBJ6qZYT4Tk21nQF05pov5oJX6c=;
        b=TGwS5WFfsi+qvIWiBKVOy5iXoY1jUd3ZZEsRDRqKLyRCU/toZB2EL9AJIfxr+vRVpv
         abuWJ1mELdkUVlMrGiooUFwm2yBEtSKHryDMTTRoffXCkXX5qzLbqg+cKMVvzHU7ml+z
         RU88JPlb2NJ4+zgpKguAicX7wQ2lYJWXci23+8Eb56mP6Hu3sYN2+54MrYgafxDRvVj5
         vUCHE6CcejgVXbl597XMV5qk61BPePNj2sSmzk9pPyCsakm2PHT8f2q2guZq1scJnBkO
         re4MZA8z8juNnlOV5imVQSvLCppXnwe4FRJR1YBOGZuQLVUTqr03dwSP/nFf2WgOhtCu
         Tc8A==
X-Gm-Message-State: AOAM532eHQA/HkVJigTsxxFlgwz8PPNSMKINAMiyDb/pakwQ6queHthH
        riVjnRt6uZVmIrtk1WQMa70XpnyR
X-Google-Smtp-Source: ABdhPJx4t9tri+hxCnXbc+rAUTV9nhDjRtA9p6wXirAoMAReM2Ri0XRAWEC5FA2Zcui9yccufLQjwA==
X-Received: by 2002:a05:6402:206e:: with SMTP id bd14mr21115410edb.105.1591602268403;
        Mon, 08 Jun 2020 00:44:28 -0700 (PDT)
Received: from [192.168.43.135] ([5.100.193.151])
        by smtp.gmail.com with ESMTPSA id d5sm11708276edu.5.2020.06.08.00.44.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Jun 2020 00:44:27 -0700 (PDT)
To:     Jens Axboe <axboe@kernel.dk>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <a2184644-34b6-88a2-b022-e8f5e7def071@gmail.com>
 <20200601045626.9291-1-xiaoguang.wang@linux.alibaba.com>
 <20200601045626.9291-2-xiaoguang.wang@linux.alibaba.com>
 <f7c648e7-f154-f4eb-586f-841f08b845fd@linux.alibaba.com>
 <8accdc46-53c9-cf89-1e61-51e7c269411c@gmail.com>
 <9f540577-0c13-fa4b-43c1-3c4d7cddcb8c@kernel.dk>
 <13c85adb-6502-f9c7-ed66-9a0adffa2dc8@gmail.com>
 <570f0f74-82a7-2f10-b186-582380200b15@gmail.com>
 <35bcf4cb-1985-74aa-5748-6ee4095acb20@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH v5 2/2] io_uring: avoid unnecessary io_wq_work copy for
 fast poll feature
Message-ID: <820263b3-b5e5-bca9-eedb-4ee4e23be2b7@gmail.com>
Date:   Mon, 8 Jun 2020 10:43:07 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <35bcf4cb-1985-74aa-5748-6ee4095acb20@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 08/06/2020 02:29, Jens Axboe wrote:
> On 6/7/20 2:57 PM, Pavel Begunkov wrote:
>> -#define INIT_IO_WORK(work, _func)				\
>> +#define INIT_IO_WORK(work)					\
>>  	do {							\
>> -		*(work) = (struct io_wq_work){ .func = _func };	\
>> +		*(work) = (struct io_wq_work){};		\
>>  	} while (0)						\
>>  
> 
> Would be nice to optimize this one, it's a lot of clearing for something
> we'll generally not use at all in the fast path. Or at least keep it
> only for before when we submit the work for async execution.

Let's leave it to Xiaoguang and the series of the topic.

> 
> From a quick look at this, otherwise looks great! Please do split and
> submit this.

Sure. Have great time off!


-- 
Pavel Begunkov
