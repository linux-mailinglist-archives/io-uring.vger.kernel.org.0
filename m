Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87C5014C3E6
	for <lists+io-uring@lfdr.de>; Wed, 29 Jan 2020 01:20:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726402AbgA2AUD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Jan 2020 19:20:03 -0500
Received: from mail-pg1-f180.google.com ([209.85.215.180]:33553 "EHLO
        mail-pg1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbgA2AUD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 28 Jan 2020 19:20:03 -0500
Received: by mail-pg1-f180.google.com with SMTP id 6so7908908pgk.0
        for <io-uring@vger.kernel.org>; Tue, 28 Jan 2020 16:20:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8kyp/VrhKERhG+K9hmS2Utzgr/wVLR2b6aoPqZM79B8=;
        b=r0kpkmQnfZmk9IbPJO4MAEgMnD2y/qsDQvmgioR/iMb4vvB/K8JRT1+0ktFzm2jpPK
         VKX9vXncytbjxDo0X/4a7CKFfOZrFk78e1xncDUYVSeokq3c2zX3wwvZ20AoIdH6RtbR
         o+eq7J6JmE7m1cU/CfOzTONCCdu+/XaJcg1Q33sp5B3RgjQiwLIby2YQp0ijAe1CZW0w
         n26pZBYIQ8GP7Qa8tirpkEKdaZOipH0R0rQlRoV4J31HunXjSpBIQBNaWIJgZ4gvGU3+
         KGGj2h8kMovtRqeN46OoQOCB3pK7HwJ8SkSsGFM0x4sL8xbEUiVstCG27ukIcdTUPhAi
         o8FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8kyp/VrhKERhG+K9hmS2Utzgr/wVLR2b6aoPqZM79B8=;
        b=CEwFlBmX0kYTi5rgE3xiXCWRVcCdcL04ZZ/UjruMRpl43W++xkfuuCdJuUh0oGAuCv
         oUo6p06Bv+XToveOtXUFk7EvcITlbJN+WzbuAfzCVtMV+SoDO+6wczAuuzj2U56k+G7Q
         I5K4+erw0C7dFqk0sbt3IyXSZ979v+y+psgHpACo+o7WJiopV8Wf5mLX8hNLIWSx3XFV
         UdCg0HDmD+tNefTHnA89cv02iQUOZQXM5VQ6M+WJyFGYVBbRPhgRgKDxzp+722xMIg1U
         g6ro4cWGiWIvc2bscKIR00UgHxcd+/ZKRZ8OZUWn6S9J3boQdXWJxpPU3wraisDxRiSy
         ijHg==
X-Gm-Message-State: APjAAAXUYkQb7bXzJLDsYd9YAvc6Ff3PDzCx1oa1PfwLUnfZ3/bO8ray
        8P7aZP7qtkJl8GzXsRDpFDXqwA==
X-Google-Smtp-Source: APXvYqxj/VTK9uE+Yaw3RPpOWhOxp4InAorRUcwedVhsztPskMNJGVyfs9h+72dJLxMSsxQvo1THTw==
X-Received: by 2002:a63:5d4d:: with SMTP id o13mr26855190pgm.182.1580257202717;
        Tue, 28 Jan 2020 16:20:02 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id x65sm186209pfb.171.2020.01.28.16.20.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jan 2020 16:20:02 -0800 (PST)
Subject: Re: IORING_REGISTER_CREDS[_UPDATE]() and credfd_create()?
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Stefan Metzmacher <metze@samba.org>
Cc:     io-uring <io-uring@vger.kernel.org>,
        Linux API Mailing List <linux-api@vger.kernel.org>
References: <ea9f2f27-e9fe-7016-5d5f-56fe1fdfc7a9@samba.org>
 <d6bc8139-abbe-8a8d-7da1-4eeafd9eebe7@kernel.dk>
 <688e187a-75dd-89d9-921c-67de228605ce@samba.org>
 <b29e972e-5ca0-8b5f-46b3-36f93d865723@kernel.dk>
 <1ac31828-e915-6180-cdb4-36685442ea75@kernel.dk>
 <0d4f43d8-a0c4-920b-5b8f-127c1c5a3fad@kernel.dk>
 <b88f0590-71c9-d2bd-9d17-027b05d30d7a@kernel.dk>
 <2d7e7fa2-e725-8beb-90b9-6476d48bdb33@gmail.com>
 <6c401e23-de7c-1fc1-4122-33d53fcf9700@kernel.dk>
 <35eebae7-76dd-52ee-58b2-4f9e85caee40@kernel.dk>
 <d3f9c1a4-8b28-3cfe-de88-503837a143bc@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <c9e58b5c-f66e-8406-16d5-fd6df1a27e77@kernel.dk>
Date:   Tue, 28 Jan 2020 17:20:00 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <d3f9c1a4-8b28-3cfe-de88-503837a143bc@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/28/20 5:10 PM, Pavel Begunkov wrote:
>>>> Checked out ("don't use static creds/mm assignments")
>>>>
>>>> 1. do we miscount cred refs? We grab one in get_current_cred() for each async
>>>> request, but if (worker->creds != work->creds) it will never be put.
>>>
>>> Yeah I think you're right, that needs a bit of fixing up.
>>
> 
> Hmm, it seems it leaks it unconditionally, as it grabs in a ref in
> override_creds().
> 

We grab one there, and an extra one. Then we drop one of them inline,
and the other in __io_req_aux_free().

-- 
Jens Axboe

