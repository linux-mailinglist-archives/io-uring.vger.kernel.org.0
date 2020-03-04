Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FEED179856
	for <lists+io-uring@lfdr.de>; Wed,  4 Mar 2020 19:48:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730149AbgCDSsF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 4 Mar 2020 13:48:05 -0500
Received: from mail-il1-f196.google.com ([209.85.166.196]:36247 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729600AbgCDSsF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 4 Mar 2020 13:48:05 -0500
Received: by mail-il1-f196.google.com with SMTP id b17so2736395iln.3
        for <io-uring@vger.kernel.org>; Wed, 04 Mar 2020 10:48:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=S9W7e0eEucLRc1ffg2OOLPtWfKH/j6fIgfCoT9zkmQ4=;
        b=sruLBKDXI+8Re66Y+pWX8pNUETxHXEbhvy5dnTtswbvWs5f5SR9ZMgjcV+MVofdwr4
         gg1Ju2kOUjY/nPmXMSVmqkWPj5FGdh7PApD6CKl+lkoUtYVmrrgnJQQVv///uq4KOHAT
         Xgd5tSc7aXzPQxIleSo8JgEQ594fi0l4XuCUwuiD5rBTPeyy3eg7E9u/w49YqJR+kp+C
         0TAUTXW+Bq/tq56HcXrlOzF5lTs0WVcOhyxOI7EHlsa2dQbZDrMN36EQCzyL4PkV9GF5
         chkQjw0uKaBgcIRpMKYUsTvwM4BVn8qts5lJEuLQoa+O1y7SBQS0wExrI6wJXChvJemH
         OvhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=S9W7e0eEucLRc1ffg2OOLPtWfKH/j6fIgfCoT9zkmQ4=;
        b=ggxFKR71LZZEDoOj3SdgSQ8KC+3pjj9kMWYH4ye4MOZyyCWXMrnXocJZXmSgZQ/ALP
         0WnfFss/4Q7k4uqN0NV4IqiiKF6B9TLQbRgPW1WW3FeDj2uHfvjrA9yWbFLEmOHBtLK/
         DJaJSy+OiAIUeRei/6w/AD8K+IUqb6YQgb5x7+yaMJFafHte1VxV0LogzXANu48DQzF1
         yusqOw3bPuJ+oYnFp02qJQzFfgBzkMBXQUQYcKZNCow6qZvLY/Z966B9mqdK7jXjKJLa
         T2CdJhbxe/ZkNfIT4JcXzlKwVxU9oNR+6jBuIWxjA2+6oz+2h7lGRHorCj6urrNS0l+H
         yzEw==
X-Gm-Message-State: ANhLgQ3NVYnhSZy5Me5ElmY/sDWgUlB7PWaCW+QwFm1o1/1Hovs2/XR7
        m3z46hAzEs2aCAlRet45f941Sw==
X-Google-Smtp-Source: ADFU+vuZeP7g1drPgTEgVEd4czUpvJueOeRQ2BqyKlM1IT4mE7yQ2PMNjMvQCiGedR/5pUsb+nBRtw==
X-Received: by 2002:a92:d782:: with SMTP id d2mr4233240iln.42.1583347684414;
        Wed, 04 Mar 2020 10:48:04 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id c12sm9381900ile.12.2020.03.04.10.48.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Mar 2020 10:48:03 -0800 (PST)
Subject: Re: [PATCH 0/4] io-wq/io_uring locking optimisation
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1583314087.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <9aeadaac-b225-7988-cd43-d0db565961e6@kernel.dk>
Date:   Wed, 4 Mar 2020 11:48:02 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <cover.1583314087.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/4/20 6:14 AM, Pavel Begunkov wrote:
> [1-3] are shedding excessive locking of @wqe's and @worker's spinlocks
> from io_worker_handle_work().
> 
> [4] removes an extra pair of refcount get/put by making former io_put_work()
> to own the submission reference. It also changes io-wq get/put API
> and renames io_put_work() into io_free_work() to reflect it.

LGTM, and tests out fine so far - applied, thanks.

-- 
Jens Axboe

